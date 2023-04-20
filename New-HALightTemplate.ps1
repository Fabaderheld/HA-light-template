#requires -Modules powershell-yaml

<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Generates a yml configuration for a Home Assistant light template (https://www.home-assistant.io/integrations/light.template/) for the use
    of a combination of a smart switch and a smart bulb e.g. Ikea Tradfri Bulb and Sonoff M5 Wall Switch, so the both are treated as ONE light entity
    Advantages are the the light bulb is indepent of Home Assistant but still manageable
.EXAMPLE
    PS C:\> ./New-HALightTemplate.ps1 -SwitchID switch.test -LightID light.test -FriendlyName "Test Light" -UniqueID "test_light" -EntityID "test_light" -TemplateFile "/tmp/test_light.yaml"
    Creates a new template 'test_light', FriendlyName 'Test Light' containing LightEntity light.test and SwitchEntity switch.test
.PARAMETER SwitchID
    Entity ID of of the switch, must start with switch.*
.PARAMETER LightID
    Entity ID of the light(s), must start with light.*, if multiple lights are used an group will be created and used with the template
.PARAMETER FriendlyName
    Friendly Name in Home Assistant
.PARAMETER UniqueID
    Unique ID for Home Assistant, required to manage entity from within HA GUI
.PARAMETER EntityID
    Name for the new light template combining switch and light, this will be the new light.%EntityID% Entity ID
.PARAMETER TemplateFile
    Name for the new light template file
.PARAMETER Brightness
    Enables Brightness for Light
.PARAMETER Color
    Enables Color for Light
.PARAMETER Temperature
    Enables Color Temperature for Light
.NOTES
    requires HA configuration split up set up, https://www.home-assistant.io/docs/configuration/splitting_configuration/
#>


[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    [ValidatePattern("(switch.).*")]
    [Alias("SwitchEntity")]
    $SwitchID,

    [Parameter(Mandatory)]
    [ValidatePattern("(light.).*")]
    [String[]]
    [Alias("LightEntity")]
    $LightID,

    [Parameter(Mandatory)]
    [String]
    $FriendlyName,

    [Parameter(Mandatory)]
    [String]
    $UniqueID,

    [Parameter(Mandatory)]
    [String]
    [Alias("TemplateName")]
    $EntityID,

    [Parameter(Mandatory)]
    [String]
    $TemplateFile,

    [Switch]
    $Brightness,

    [Switch]
    $Color,

    [Switch]
    $Temperature
)

# Sanitize EntityID from domain perfix
$EntityID = $EntityID.split('light.')[-1]

# if more than one light entity is passed, generate light group
if ($LightID.count -gt 1) {

    $Name = "$($FriendlyName) Group"

    if ($TemplateFile -like "*.yaml") {
        $GroupTemplateFile = "$($TemplateFile.Split(".yaml")[0])-Group.yaml"
    }
    if ($TemplateFile -like "*.yml") {
        $GroupTemplateFile = "$($TemplateFile.Split(".yaml")[0])-Group.yml"
    }

    # Create light group
    $Group = [ordered]@{
        platform  = "group"
        name      = $Name
        unique_id = $UniqueID
        entities  = $LightID
    }
    # Export template file again
    $Group | ConvertTo-Yaml -OutFile $GroupTemplateFile -KeepArray

    # convert Name into entityID, repalce spaces with "_" and to lower case
    $LightID = "light.$($Name.ToLower().Replace(" ","_"))"
}

# General config for yaml template
$Light = @(
    [ordered]@{
        platform = "template"
        lights   = [ordered]@{
            $EntityID = [ordered]@{
                friendly_name  = $FriendlyName
                unique_id      = $UniqueID
                turn_on        = [ordered]@{
                    service = "switch.turn_on"
                    data    = @{}
                    target  = @{
                        entity_id = $SwitchID
                    }
                }
                turn_off       = [ordered]@{
                    service = "switch.turn_off"
                    data    = @{}
                    target  = @{
                        entity_id = $SwitchID
                    }
                }
                value_template = "{{ states('$SwitchID') }}"
                level_template = "{{ state_attr('$LightID','brightness')}}"
                set_level      = @(
                    [ordered]@{
                        service = "switch.turn_on"
                        data    = @{}
                        target  = @{
                            entity_id = $SwitchID
                        }
                    },
                    [ordered]@{
                        service = "light.turn_on"
                        data    = @{
                            brightness = "{{ brightness }}"
                        }
                        target  = @{
                            entity_id = $LightID
                        }
                    }
                )
            }
        }
    }
)

# If color set add to template
if ($Color) {
    $Light.lights.$EntityID["color_template"] = "{{states('$LightID.temperature_input') | int}}" # Need to fix $LightID attribute for color
    $Light.lights.$EntityID["set_color"] = @(
        [ordered]@{
            service = "switch.turn_on"
            data    = @{}
            target  = @{
                entity_id = $SwitchID
            }
        },
        [ordered]@{
            service = "light.turn_on"
            data    = @{
                rgb_color = "{{ color_temp }}"
            }
            target  = @{
                entity_id = $LightID
            }
        }
    )
}

# If temperature set add to template
if ($Temperature) {
    $Light.lights.$EntityID["temperature_template"] = "{{states('$LightID.temperature_input') | int}}"# Need to fix $LightID attribute for temperature
    $Light.lights.$EntityID["set_temperature"] = @(
        [ordered]@{
            service = "switch.turn_on"
            data    = @{}
            target  = @{
                entity_id = $SwitchID
            }
        },
        [ordered]@{
            service = "light.turn_on"
            data    = @{
                color_temp = "{{ color_temp }}"
            }
            target  = @{
                entity_id = $LightID
            }
        }
    )
}

# Export template file again
$Light | ConvertTo-Yaml -OutFile $TemplateFile -KeepArray
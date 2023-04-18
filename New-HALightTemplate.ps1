#requires -Modules powershell-yaml

<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Generates a yml configuration for a Home Assistant light template (https://www.home-assistant.io/integrations/light.template/) for the use
    of a combination of a smart switch and a smart bulb e.g. Ikea Tradfri Bulb and Sonoff M5 Wall Switch, so the both are treated as ONE light entity
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.PARAMETER SwitchID
    Entity ID of of the switch
.PARAMETER BulbID
    Entity ID of the bulb
.PARAMETER FriendlyName
    Friendly Name in Home Assistant
.PARAMETER UniqueID
    Unique ID for Home Assistant, required to manage entity from within HA GUI
.PARAMETER TemplateName
    Name for the new light template combining switch and bulb
.PARAMETER TemplateFile
    Name for the new light template file
.PARAMETER Brightness
    Enables Brightness for Bulb
.PARAMETER Color
    Enables Color for Bulb
.PARAMETER Temperature
    Enables Color Temperature for Bulb
#>


[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $SwitchID,
    [Parameter(Mandatory)]
    [String]
    $BulbID,
    [Parameter(Mandatory)]
    [String]
    $FriendlyName,
    [Parameter(Mandatory)]
    [String]
    $UniqueID,
    [Parameter(Mandatory)]
    [String]
    $TemplateName,
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

# General config for yaml template
$Light = @(
    [ordered]@{
        platform = "template"
        lights   = [ordered]@{
            $TemplateName = @{
                friendly_name  = $FriendlyName
                unique_id      = $UniqueID
                turn_on        = [ordered]@{
                    service = "switch.turn_on"
                    data    = "{}"
                    target  = @{
                        entity_id = $SwitchID
                    }
                }
                turn_off       = [ordered]@{
                    service = "switch.turn_off"
                    data    = "{}"
                    target  = @{
                        entity_id = $SwitchID
                    }
                }
                value_template = "{{ states('$SwitchID') }}"
                level_template = "{{ state_attr('$BulbID','brightness')}}"
                set_level      = @(
                    [ordered]@{
                        service = "switch.turn_on"
                        data    = "{}"
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
                            entity_id = $BulbID
                        }
                    }
                )
            }
        }
    }
)
# If color set add to template
if ($Color) {
    $Light.lights.$TemplateName["color_template"] = "{{states('$BulbID.temperature_input') | int}}" # Need to fix $BulbID attribute for color
    $Light.lights.$TemplateName["set_color"] = @(
        [ordered]@{
            service = "switch.turn_on"
            data    = "{}"
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
                entity_id = $BulbID
            }
        }
    )
}

# If temperature set add to template
if ($Temperature) {
    $Light.lights.$TemplateName["temperature_template"] = "{{states('$BulbID.temperature_input') | int}}"# Need to fix $BulbID attribute for temperature
    $Light.lights.$TemplateName["set_temperature"] = @(
        [ordered]@{
            service = "switch.turn_on"
            data    = "{}"
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
                entity_id = $BulbID
            }
        }
    )
}

# Export template file again
$Light | ConvertTo-Yaml -OutFile $TemplateFile -KeepArray

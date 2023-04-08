#requires -Modules powershell-yaml

<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.PARAMETER SwitchID
    Entity ID of of the switch
.PARAMETER BlubID
    Entity ID of the bulb
.PARAMETER TemplateName
    Name for the new light template combing switch and blub
#>


[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $SwitchID,
    [Parameter(Mandatory)]
    [String]
    $BlubID,
    [Parameter(Mandatory)]
    [String]
    $TemplateName,
    [Switch]
    $Brightness,
    [Switch]
    $Color,
    [Switch]
    $Temperature
)


$Light = @(
    [ordered]@{
        platform = "template"
        lights   = [ordered]@{
            $TemplateName = @{
                firendly_name  = "Test"
                unique_id      = "unique_test"
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
                level_template = "{{ state_attr('$BlubID','brightness')}}"
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
                            entity_id = $BlubID
                        }
                    }
                )
            }
        }
    }
)
# If color set add to template
if ($Color) {
    $Light.lights.$TemplateName["color_template"] = "{{states('$BlubID.temperature_input') | int}}" # Need to fix $BlubID attribute for color
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
                entity_id = $BlubID
            }
        }
    )
}

# If tempature set add to template
if ($Temperature) {
    $Light.lights.$TemplateName["temperature_template"] = "{{states('$BlubID.temperature_input') | int}}"# Need to fix $BlubID attribute for tempature
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
                entity_id = $BlubID
            }
        }
    )
}
# Export template file again
$Light | ConvertTo-Yaml -OutFile $TemplateFile

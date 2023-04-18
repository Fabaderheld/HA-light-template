---
external help file: -help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# New-HALightTemplate.ps1

## SYNOPSIS

Short description

## SYNTAX

### __AllParameterSets

```
New-HALightTemplate.ps1 [-SwitchID] <String> [-LightID] <String> [-FriendlyName] <String> [-UniqueID] <String> [-TemplateName] <String> [-TemplateFile] <String> [-Brightness] [-Color] [-Temperature] [<CommonParameters>]
```

## DESCRIPTION

Generates a yml configuration for a Home Assistant light template (https://www.home-assistant.io/integrations/light.template/) for the use
of a combination of a smart switch and a smart bulb e.g.
Ikea Tradfri Bulb and Sonoff M5 Wall Switch, so the both are treated as ONE light entity


## EXAMPLES

### Example 1: EXAMPLE 1

```
./New-HALightTemplate.ps1 -SwitchID switch.test -LightID light.test -FriendlyName "Test Light" -UniqueID "test_light" -TemplateName "test_light" -TemplateFile "/tmp/test_light.yaml"
Creates a new template 'test_light', FriendlyName 'Test Light' containing LightEntity light.test and SwitchEntity switch.test
```








## PARAMETERS

### -Brightness

Enables Brightness for Light

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Color

Enables Color for Light

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -FriendlyName

Friendly Name in Home Assistant

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 2
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -LightID

Entity ID of the light

```yaml
Type: String
Parameter Sets: (All)
Aliases: LightEntity
Accepted values: 

Required: True (All) False (None)
Position: 1
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -SwitchID

Entity ID of of the switch

```yaml
Type: String
Parameter Sets: (All)
Aliases: SwitchEntity
Accepted values: 

Required: True (All) False (None)
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Temperature

Enables Color Temperature for Light

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -TemplateFile

Name for the new light template file

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 5
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -TemplateName

Name for the new light template combining switch and light

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 4
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -UniqueID

Unique ID for Home Assistant, required to manage entity from within HA GUI

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 3
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## NOTES

requires HA configuration split up set up, https://www.home-assistant.io/docs/configuration/splitting_configuration/


## RELATED LINKS

Fill Related Links Here


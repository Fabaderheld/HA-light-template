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
New-HALightTemplate.ps1 [-SwitchID] <String> [-BlubID] <String> [-TemplateName] <String> [-TemplateFile] <String> [-Brightness] [-Color] [-Temperature] [<CommonParameters>]
```

## DESCRIPTION

Generates a yml configuration for a Home Assistant light template (https://www.home-assistant.io/integrations/light.template/) for the use
of a combination of a smart switch and a smart bulb e.g.
Ikea Tradfri Bulb and Sonoff M5 Wall Switch


## EXAMPLES

### Example 1: EXAMPLE 1

```
<example usage>
Explanation of what the example does
```








## PARAMETERS

### -BlubID

Entity ID of the bulb

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 1
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Brightness

Enables Brightness for Bulb

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

Enables Color for Bulb

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

### -SwitchID

Entity ID of of the switch

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: 

Required: True (All) False (None)
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Temperature

Enables Color Temperature for Bulb

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

{{ Fill TemplateFile Description }}

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

### -TemplateName

Name for the new light template combing switch and blub

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


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## NOTES



## RELATED LINKS

Fill Related Links Here

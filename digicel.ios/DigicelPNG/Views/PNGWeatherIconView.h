//
//  PNGWeatherIconView.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PNGWeatherType
{
    PNGWeatherTypeCloudy,
    PNGWeatherTypeDrizzle,
    PNGWeatherTypeHail,
    PNGWeatherTypeLightning,
    PNGWeatherTypeOvercast,
    PNGWeatherTypeSunny,
    PNGWeatherTypeWindy
}PNGWeatherType;

@interface PNGWeatherIconView : UIView

@property (nonatomic) NSInteger temperature;
@property (nonatomic) PNGWeatherType weatherType;

@end

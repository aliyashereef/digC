//
//  PNGWeatherIconView.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGWeatherIconView.h"

@interface PNGWeatherIconView ()

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;


@end

@implementation PNGWeatherIconView

#pragma mark - Properties

- (void)setTemperature:(NSInteger)temperature
{
    self.temperatureLabel.text = [NSString stringWithFormat:@"%d°", (int)temperature];
}

- (void)setWeatherType:(PNGWeatherType)weatherType
{
    UIImage *image;
    
    switch (weatherType) {
        case PNGWeatherTypeCloudy:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherCloudy];
            break;
        case PNGWeatherTypeDrizzle:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherDrizzle];
            break;
        case PNGWeatherTypeHail:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherHail];
            break;
        case PNGWeatherTypeLightning:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherLightning];
            break;
        case PNGWeatherTypeOvercast:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherOvercast];
            break;
        case PNGWeatherTypeSunny:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherSunny];
            break;
        case PNGWeatherTypeWindy:
            image = [UIImage imageNamed:PNGStoryboardImageWeatherWindy];
            break;
        default:
            break;
    }
    
    self.weatherImageView.image = image;
}



@end

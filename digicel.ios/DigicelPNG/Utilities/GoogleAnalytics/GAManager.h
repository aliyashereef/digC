//
//  GAManager.h
//  DigicelPNG
//
//  Created by Srijith on 21/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAManager : NSObject

//start google analytics tracking
+ (void)startTracking;

//track app screens
+ (void)trackView:(NSString *)view;

//Track events
+ (void)trackEventsWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label;

@end

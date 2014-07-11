//
//  GAManager.m
//  DigicelPNG
//
//  Created by Srijith on 21/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "GAManager.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation GAManager

+ (void)startTracking {
    //start google analytics tracking
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
}

+ (void)trackView:(NSString *)view {
    //track app screens
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:view];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
}

+ (void)trackEventsWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label {
    //Track events
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action label:label
                                                           value:nil] build]];
}

@end

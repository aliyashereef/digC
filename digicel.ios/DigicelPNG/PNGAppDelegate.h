//
//  PNGAppDelegate.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MadsSDK/MadsSDK.h>
#import "PNGUser.h"
#import <FacebookSDK/FacebookSDK.h>

@interface PNGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) PNGUser *loggedInUser;
@property (strong, nonatomic) FBSession *session;
@end

//
//  PNGAppDelegate.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGAppDelegate.h"
#import "PNGStoryBoardManager.h"
#import <Parse/Parse.h>
#import "PNGUser.h"
#import "PNGCategory.h"
#import "PNGArticle.h"
#import "PNGStory.h"
#import "PNGFile.h"
#import "PNGComment.h"
#import "GAManager.h"
#import <Raygun4iOS/Raygun.h>

@implementation PNGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MadsAdServer startWithLocationEnabled:YES withLocationPurpose:nil withLocationUpdateTimeInterval:30.0];
    [self initialiseParse:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [GAManager startTracking];
    
    // Raygun configuration
    [Raygun sharedReporterWithApiKey:RAYGUN_API_KEY];
    
    // Setting custom font (Lato) for nav bar titles and buttons throughout the app
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato-Bold" size:16.0f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato-Regular" size:16.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.window makeKeyAndVisible];
    // Shows version number and build number in the status bar area.
    [PNGUtilities showVersionNumberOnWindow];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"email", @"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MadsAdServer stop];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [MadsAdServer startWithLocationEnabled:YES withLocationPurpose:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MadsAdServer stop];
    [self.session close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Getter

//  Getter method for logged in user.
- (PNGUser *)loggedInUser {
    if(!_loggedInUser) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:kUserInfo];
        if(userInfo) {
            _loggedInUser = [PNGUser createUserFromDictionary:userInfo];
            return _loggedInUser;
        } else {
            return nil;
        }
    } else {
        return _loggedInUser;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Parse methods

- (void)initialiseParse:(NSDictionary *)launchOptions {
    //parse now pointed to Staging_PNGLoop
//    [PNGUser registerSubclass];
    [PNGCategory registerSubclass];
    [PNGArticle registerSubclass];
    [PNGStory registerSubclass];
    [PNGFile registerSubclass];
    [PNGComment registerSubclass];
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

}

#pragma mark - Facebook methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
    }
    
    // Handle errors
    if (error){
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){

        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error

            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}


@end

//
//  MadsAdServer.h
//  MadsSDK
//
//  Created by Alexander van Elsas on 2/24/12.
//  Copyright (c) 2012 Mads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kMadsSDKVersion @"v4.3.10"

@interface MadsAdServer : NSObject

/** Start the Mads AdServer
 *
 * The MadsAdServer needs to be initialized once by calling it's startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose withAppTargetingEnabled:(BOOL) enableApptargeting method during
 * didFinishLaunchingWithOptions and in applicationWillEnterForeground. This call ensures that the ad server is initialized properly.
 *
 * The Mads Ad Server has 2 global targeting methods that can improve the effectiveness of the advertisement served. One is the use of location services and the other is the use of app metadata to improve targeting.
 *
 * @param enableLocation turn location targeting on or off
 *
 * If YES location will be used in advertisement targeting, and the user may be promptedto allow access to location services. 
 *
 * If NO location will not be used for advertisement targeting.
 * Note: be aware that if you turn location services on, the user will be prompted by iOS if the user has not given the app permission to access location. We would suggest you only enable location for advertisement if the app itself already uses location services.
 *
 * @param withLocationPurpose Add a reason for asking permission to access location
 *
 * Customize the prompt requesting permission to access location by adding a specific purpose to the dialogue (e.g. NSLocalizedString(@"To provide local weather information", nil) )
 *
 * @param enableApptargeting turn app targeting on or off
 *
 * If YES app metadata will be used in advertisement targeting to serve more effective advertisement campaigns. 
 *
 * If NO, app meta data is not used for advertisement targeting purposes.
 * Note: We recommend enableApptargeting to be enabled as it will significantly improve ad performance
 *
 * @deprecated This method has been deprecated in v4.3.8.
 * Use [startWithLocationEnabled:withLocationPurpose:](#//api/name/startWithLocationEnabled:withLocationPurpose:) instead.
 */
+(void) startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose withAppTargetingEnabled:(BOOL) enableApptargeting __attribute__((deprecated("use startWithLocationEnabled:withLocationPurpose: instead")));

/** Start the Mads AdServer
 *
 * The MadsAdServer needs to be initialized once by calling it's startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose method during
 * didFinishLaunchingWithOptions and in applicationWillEnterForeground. This call ensures that the ad server is initialized properly.
 *
 * The Mads Ad Server has a global targeting method that can improve the effectiveness of the advertisement served. That is the use of location services to improve targeting. This initializer uses a default time interval of 5 mins for location updates. To specify a preferred time interval, use the initializer [startWithLocationEnabled:withLocationPurpose:withLocationUpdateTimeInterval:](#//api/name/startWithLocationEnabled:withLocationPurpose:withLocationUpdateTimeInterval:) instead.
 *
 * @param enableLocation turn location targeting on or off
 *
 * If YES location will be used in advertisement targeting, and the user may be promptedto allow access to location services.
 *
 * If NO location will not be used for advertisement targeting.
 * Note: be aware that if you turn location services on, the user will be prompted by iOS if the user has not given the app permission to access location. We would suggest you only enable location for advertisement if the app itself already uses location services.
 *
 * @param withLocationPurpose Add a reason for asking permission to access location
 *
 * Customize the prompt requesting permission to access location by adding a specific purpose to the dialogue (e.g. NSLocalizedString(@"To provide local weather information", nil) )
 *
 */

+(void) startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose;

/** Start the Mads AdServer
 *
 * The MadsAdServer needs to be initialized once by calling it's startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose method during
 * didFinishLaunchingWithOptions and in applicationWillEnterForeground. This call ensures that the ad server is initialized properly.
 *
 * The Mads Ad Server has a global targeting method that can improve the effectiveness of the advertisement served. That is the use of location services to improve targeting.
 * @param enableLocation turn location targeting on or off
 *
 * If YES location will be used in advertisement targeting, and the user may be promptedto allow access to location services.
 *
 * If NO location will not be used for advertisement targeting.
 * Note: be aware that if you turn location services on, the user will be prompted by iOS if the user has not given the app permission to access location. We would suggest you only enable location for advertisement if the app itself already uses location services.
 *
 * @param purpose Add a reason for asking permission to access location
 *
 * Customize the prompt requesting permission to access location by adding a specific purpose to the dialogue (e.g. NSLocalizedString(@"To provide local weather information", nil) )
 *
 * @param locationUpdateTimeInterval Location update time interval, in seconds.
 *
 * The value of locationUpdateTimeInterval determines time interval between location updating. This interval is counted after finish detecting location, so the location will start updating only after detecting is finished and time interval is passed. Setting to 0 will continuously updates. All positive values enable updates. The default value is 300s.
 *
 */

+(void) startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose withLocationUpdateTimeInterval:(NSTimeInterval) locationUpdateTimeInterval;

/** Stop the Mads AdServer
 *
 * The MadsAdServer needs to be closed down to save as much memory as possible when the app
 * terminates or goes into the background. You can stop the MadsAdserver by calling it's stop 
 * method during applicationWillTerminate and in applicationWillEnterBackground 
 */
+(void) stop;

/** see the current value of the useLocationServices property that is set during the ad server initialization
 *
 *
 * @warning Important: Be aware that of your app doesn't use location services for anything else, setting locaten services enabled in the ad server initialization will cause a popup to appear requesting the user's permission to use location services
 *
 */
+(BOOL) locationServicesEnabled;


/** see the current value of the enableApptargeting parameter that is set during the ad server initialization.
 *
 */
//+(BOOL) appTargetingEnabled;

@end

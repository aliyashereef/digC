//
//  PNGUser.h
//  DigicelPNG
//
//  Created by Srijith on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>

@interface PNGUser : NSObject //<PFSubclassing>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *displayname;
@property (nonatomic, strong) NSString *niceName;
@property (nonatomic, strong) NSString *avatar;

//  Returns user details as a dictionary
- (NSMutableDictionary *)getUserDictionary;

//  Returns a user object from the given user details dictionary
+ (PNGUser *)createUserFromDictionary:(NSDictionary *)userDictionary;

//  Setting user details
- (void)setUserDetails:(NSDictionary *)userDictionary;


@end

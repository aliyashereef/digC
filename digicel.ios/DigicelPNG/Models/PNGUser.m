//
//  PNGUser.m
//  DigicelPNG
//
//  Created by Srijith on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGUser

//  Returns user details as a dictionary
- (NSMutableDictionary *)getUserDictionary {
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    if(self.firstName) {
        [userDictionary setObject:self.firstName forKey:@"firstname"];
        [userDictionary setObject:self.firstName forKey:@"first_name"];
    }
    if(self.lastName) {
        [userDictionary setObject:self.lastName forKey:@"lastname"];
        [userDictionary setObject:self.lastName forKey:@"last_name"];
    }
    if(self.email) {
        [userDictionary setObject:self.email forKey:@"email"];
        [userDictionary setObject:self.email forKey:@"username"];
    }
    if(self.userId) {
        [userDictionary setObject:self.userId forKey:@"id"];
        [userDictionary setObject:self.userId forKey:@"user_id"];
    }
    if(self.displayname) {
        [userDictionary setObject:self.displayname forKey:@"displayname"];
    }
    if(self.avatar) {
        [userDictionary setObject:self.avatar forKey:@"avatar"];
    }
    if (self.niceName) {
        [userDictionary setObject:self.niceName forKey:@"nicename"];
    }
    
    return userDictionary;
}

//  Returns a user object from the given user details dictionary
+ (PNGUser *)createUserFromDictionary:(NSDictionary *)userDictionary {
    PNGUser *user = [[PNGUser alloc] init];
    [user setUserDetails:userDictionary];
    return user;
}

//  Setting user details
- (void)setUserDetails:(NSDictionary *)userDictionary {
    if(!userDictionary)
        return;
    if([userDictionary valueForKey:@"id"]) {
        self.userId = [userDictionary valueForKey:@"id"];
    }
    if([userDictionary valueForKey:@"wp_user_id"]) {
        self.userId = [userDictionary valueForKey:@"wp_user_id"];
    }
    if([userDictionary valueForKey:@"firstname"]) {
        self.firstName = [userDictionary valueForKey:@"firstname"];
    }
    if([userDictionary valueForKey:@"first_name"]) {
        self.firstName = [userDictionary valueForKey:@"first_name"];
    }
    if([userDictionary valueForKey:@"lastname"]) {
        self.lastName = [userDictionary valueForKey:@"lastname"];
    }
    if([userDictionary valueForKey:@"last_name"]) {
        self.lastName = [userDictionary valueForKey:@"last_name"];
    }
    if([userDictionary valueForKey:@"email"]) {
        self.email = [userDictionary valueForKey:@"email"];
        self.username = [userDictionary valueForKey:@"email"];
    }
    if([userDictionary valueForKey:@"displayname"]) {
        self.displayname = [userDictionary valueForKey:@"displayname"];
    }
    if([userDictionary valueForKey:@"name"]) {
        self.displayname = [userDictionary valueForKey:@"name"];
    }
    if([userDictionary valueForKey:@"avatar"]) {
        if(![[userDictionary valueForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
            self.avatar = [userDictionary valueForKey:@"avatar"];
        }
    }
    if ([userDictionary valueForKey:@"nicename"]) {
        self.niceName = [userDictionary valueForKey:@"nicename"];
    }
}

@end

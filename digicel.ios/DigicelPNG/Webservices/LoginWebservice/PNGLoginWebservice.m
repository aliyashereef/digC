//
//  PNGLoginWebservice.m
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGLoginWebservice.h"

@implementation PNGLoginWebservice

//  User login webservice. Set the email id and password.
//  Completion handlers will return error message in case of any failure or
//  the user object filled with all user details.
- (void)userLogin:(NSString *)email
         password:(NSString *)password
 requestSucceeded:(void (^)(PNGUser *user))success
    requestFailed:(void (^)(NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@api/get_nonce/?controller=auth&method=generate_auth_cookie",kBaseUrl]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject valueForKey:@"nonce"]) {
            NSDictionary *loginData = @{@"username": email, @"password": password, @"nonce": [responseObject valueForKey:@"nonce"]};
            NSString *url = [NSString stringWithFormat:@"%@api/auth/generate_auth_cookie/",kBaseUrl];
            [manager GET:url parameters:loginData success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if([[responseObject valueForKey:@"status"] isEqualToString:@"ok"]) {
                    PNGUser *user = [PNGUser createUserFromDictionary:[responseObject valueForKey:@"user"]];
                    NSDictionary *userInfo = [user getUserDictionary];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[responseObject valueForKey:@"cookie"] forKey:kAuthCookie];
                    [defaults setObject:userInfo forKey:kUserInfo];
                    [defaults synchronize];
                    self.successCallback(user);
                } else {
                    self.failureCallback([responseObject valueForKey:@"error"]);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.failureCallback(error.localizedDescription);
            }];
        } else {
            self.failureCallback(@"Failed");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.failureCallback(error.localizedDescription);
    }];
}

@end

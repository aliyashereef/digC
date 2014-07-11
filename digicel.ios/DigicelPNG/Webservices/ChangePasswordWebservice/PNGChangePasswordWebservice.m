//
//  PNGChangePasswordWebservice.m
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGChangePasswordWebservice.h"

@implementation PNGChangePasswordWebservice

//  Change user password webservice. Set old and new password.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)changePassword:(NSString *)currentPassword
           newPassword:(NSString *)newPassword
      requestSucceeded:(void (^)(BOOL status))success
         requestFailed:(void (^)(NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@api/?json=get_nonce&controller=user&method=change_password",kBaseUrl]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject valueForKey:@"nonce"]) {
                 NSDictionary *dataDict = @{@"user_id": [APP_DELEGATE loggedInUser].userId,
                                            @"old_pwd":currentPassword,
                                            @"new_pwd":newPassword,
                                            @"nonce":[responseObject valueForKey:@"nonce"]};
                 NSString *url = [NSString stringWithFormat:@"%@api/user/change_password/",kBaseUrl];
                 [manager GET:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if([[responseObject valueForKey:@"status"] isEqualToString:@"ok"]) {
                         self.successCallback(YES);
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

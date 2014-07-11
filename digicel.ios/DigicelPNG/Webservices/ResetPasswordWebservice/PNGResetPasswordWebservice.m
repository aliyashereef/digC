//
//  PNGResetPasswordWebservice.m
//  DigicelPNG
//
//  Created by Arundev K S on 23/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGResetPasswordWebservice.h"

@implementation PNGResetPasswordWebservice

//  Reset password webservice. Set user email id.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)resetPasswordOfUser:(NSString *)emailId
           requestSucceeded:(void (^)(NSString *msg))success
              requestFailed:(void (^)(NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@api/user/retrieve_password/",kBaseUrl];
    [manager GET:url parameters:@{@"user_login":emailId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject valueForKey:@"status"] isEqualToString:@"ok"]) {
            self.successCallback([responseObject valueForKey:@"msg"]);
        } else {
            self.failureCallback([responseObject valueForKey:@"error"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.failureCallback(error.localizedDescription);
    }];
}

@end

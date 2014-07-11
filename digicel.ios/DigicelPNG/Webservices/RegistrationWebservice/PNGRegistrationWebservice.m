//
//  PNGRegistrationWebservice.m
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGRegistrationWebservice.h"

@implementation PNGRegistrationWebservice

//  User registration webservice. Set the user object with all mandatory fields.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)userRegistration:(PNGUser *)user
                password:(NSString *)password
        requestSucceeded:(void (^)(PNGUser *user))success
           requestFailed:(void (^)(PNGUser *user, NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    self.user = user;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@api/?json=get_nonce&controller=user&method=user_register",kBaseUrl]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject valueForKey:@"nonce"]) {
                 NSMutableDictionary *dataDict = [self createPostDictionary:password];
                 [dataDict setValue:[responseObject valueForKey:@"nonce"] forKey:@"nonce"];
                 NSString *url = [NSString stringWithFormat:@"%@api/user/user_register/",kBaseUrl];
                 [manager GET:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if(![[responseObject valueForKey:@"user_id"] isKindOfClass:[NSNull class]]) {
                         self.successCallback(_user);
                     } else {
                         self.failureCallback(_user,[[responseObject valueForKey:@"msg"] stringByReplacingOccurrencesOfString:@"Username" withString:@"Email"]);
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     self.failureCallback(_user,error.localizedDescription);
                 }];
             } else {
                 self.failureCallback(_user,@"Failed");
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.failureCallback(_user,error.localizedDescription);
         }];
}

- (NSMutableDictionary *)createPostDictionary:(NSString *)password {
    NSMutableDictionary *postDictionary = [self.user getUserDictionary];
    if(password) {
        [postDictionary setValue:password forKey:@"password"];
    }
    return postDictionary;
}

@end

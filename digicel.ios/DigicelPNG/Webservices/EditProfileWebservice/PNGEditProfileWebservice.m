//
//  PNGEditProfileWebservice.m
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGEditProfileWebservice.h"

@implementation PNGEditProfileWebservice

//  Edit user profile webservice. Set the user object with all mandatory fields.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)editProfileOfUser:(PNGUser *)user
         requestSucceeded:(void (^)(PNGUser *user))success
            requestFailed:(void (^)(PNGUser *user, NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    self.user = user;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@api/?json=get_nonce&controller=user&method=edit",kBaseUrl]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject valueForKey:@"nonce"]) {
                 NSMutableDictionary *dataDict = [self.user getUserDictionary];
                 [dataDict setValue:[responseObject valueForKey:@"nonce"] forKey:@"nonce"];
                 NSString *url = [NSString stringWithFormat:@"%@api/user/edit/",kBaseUrl];
                 [manager GET:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if([[responseObject valueForKey:@"status"] isEqualToString:@"ok"]) {
                         user.displayname = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
                         NSDictionary *dict = [user getUserDictionary];
                         [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kUserInfo];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         self.successCallback(_user);
                     } else {
                         self.failureCallback(_user,[responseObject valueForKey:@"error"]);
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


@end

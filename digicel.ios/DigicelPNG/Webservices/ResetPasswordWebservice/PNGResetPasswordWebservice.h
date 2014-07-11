//
//  PNGResetPasswordWebservice.h
//  DigicelPNG
//
//  Created by Arundev K S on 23/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef void (^resetPasswordSuccess)(NSString *msg);
typedef void (^resetPasswordFailure)(NSString *errorMsg);


@interface PNGResetPasswordWebservice : NSObject

@property (nonatomic, strong) PNGUser *user;
@property (nonatomic, strong) resetPasswordSuccess successCallback;
@property (nonatomic, strong) resetPasswordFailure failureCallback;

//  Reset password webservice. Set user email id.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)resetPasswordOfUser:(NSString *)emailId
           requestSucceeded:(void (^)(NSString *msg))success
              requestFailed:(void (^)(NSString *errorMsg))failure;

@end

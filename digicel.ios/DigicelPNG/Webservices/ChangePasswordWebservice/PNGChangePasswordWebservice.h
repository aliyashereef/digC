//
//  PNGChangePasswordWebservice.h
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUser.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^changePasswordSuccess)(BOOL status);
typedef void (^changePasswordFailure)(NSString *errorMsg);


@interface PNGChangePasswordWebservice : NSObject

@property (nonatomic, strong) changePasswordSuccess successCallback;
@property (nonatomic, strong) changePasswordFailure failureCallback;

//  Change user password webservice. Set old and new password.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)changePassword:(NSString *)currentPassword
           newPassword:(NSString *)newPassword
      requestSucceeded:(void (^)(BOOL status))success
         requestFailed:(void (^)(NSString *errorMsg))failure;

@end

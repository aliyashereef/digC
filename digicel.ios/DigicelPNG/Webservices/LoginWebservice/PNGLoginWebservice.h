//
//  PNGLoginWebservice.h
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUser.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^loginSuccess)(PNGUser *user);
typedef void (^loginFailure)(NSString *errorMsg);


@interface PNGLoginWebservice : NSObject

@property (nonatomic, strong) loginSuccess successCallback;
@property (nonatomic, strong) loginFailure failureCallback;

//  User login webservice. Set the email id and password.
//  Completion handlers will return error message in case of any failure or
//  the user object filled with all user details.
- (void)userLogin:(NSString *)email
         password:(NSString *)password
 requestSucceeded:(void (^)(PNGUser *user))success
    requestFailed:(void (^)(NSString *errorMsg))failure;

@end

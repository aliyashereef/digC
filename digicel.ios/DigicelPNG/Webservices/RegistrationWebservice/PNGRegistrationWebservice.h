//
//  PNGRegistrationWebservice.h
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUser.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^registrationSuccess)(PNGUser *user);
typedef void (^registrationFailure)(PNGUser *user, NSString *errorMsg);


@interface PNGRegistrationWebservice : NSObject

@property (nonatomic, strong) PNGUser *user;
@property (nonatomic, strong) registrationSuccess successCallback;
@property (nonatomic, strong) registrationFailure failureCallback;

//  User registration webservice. Set the user object with all mandatory fields.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)userRegistration:(PNGUser *)user
                password:(NSString *)password
        requestSucceeded:(void (^)(PNGUser *user))success
           requestFailed:(void (^)(PNGUser *user, NSString *errorMsg))failure;

@end
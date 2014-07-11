//
//  PNGEditProfileWebservice.h
//  DigicelPNG
//
//  Created by Arundev K S on 17/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUser.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^editProfileSuccess)(PNGUser *user);
typedef void (^editProfileFailure)(PNGUser *user, NSString *errorMsg);


@interface PNGEditProfileWebservice : NSObject

@property (nonatomic, strong) PNGUser *user;
@property (nonatomic, strong) editProfileSuccess successCallback;
@property (nonatomic, strong) editProfileFailure failureCallback;

//  Edit user profile webservice. Set the user object with all mandatory fields.
//  Completion handlers will return error message in case of any failure or
//  the same user object filled with all user details.
- (void)editProfileOfUser:(PNGUser *)user
         requestSucceeded:(void (^)(PNGUser *user))success
            requestFailed:(void (^)(PNGUser *user, NSString *errorMsg))failure;
@end

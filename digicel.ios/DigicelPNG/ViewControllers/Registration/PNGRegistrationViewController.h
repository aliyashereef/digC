//
//  PNGRegistrationViewController.h
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGKeyboardViewController.h"
#import <Parse/Parse.h>
#import "PNGUser.h"
#import "PNGRegistrationWebservice.h"

/*
 View controller for registering a new user.
 */

@interface PNGRegistrationViewController : PNGKeyboardViewController {
    
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmPasswordField;
    
    IBOutlet UIView *firstNameContainer;
    IBOutlet UIView *lastNameContainer;
    IBOutlet UIView *emailContainer;
    IBOutlet UIView *passwordContainer;
    IBOutlet UIView *confirmPasswordContainer;
    
    IBOutlet PNGLatoLabel *firstNameErrorLabel;
    IBOutlet PNGLatoLabel *lastNameErrorLabel;
    IBOutlet PNGLatoLabel *emailErrorLabel;
    IBOutlet PNGLatoLabel *passwordErrorLabel;
    IBOutlet PNGLatoLabel *confirmPasswordErrorLabel;
    
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet NSLayoutConstraint *scrollviewBottomSpace;
    PNGRegistrationWebservice *registrationWebservice;
}

@end

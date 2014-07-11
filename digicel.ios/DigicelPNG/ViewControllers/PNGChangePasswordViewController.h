//
//  PNGChangePasswordViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGKeyboardViewController.h"

@interface PNGChangePasswordViewController : PNGKeyboardViewController <UITextFieldDelegate> {
    
    IBOutlet UILabel *oldPasswordErrorLabel;
    IBOutlet UILabel *newPasswordErrorLabel;
    IBOutlet UILabel *confirmPasswordErrorLabel;
    IBOutlet UIButton *doneButton;
}

@end

//
//  PNGEditProfileViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGEditProfileWebservice.h"

@interface PNGEditProfileViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UILabel *firstNameErrorLabel;
    IBOutlet UILabel *lastNameErrorLabel;
    IBOutlet UILabel *emailErrorLabel;
}

@property (nonatomic, getter = isRegistration) BOOL registration;

@end

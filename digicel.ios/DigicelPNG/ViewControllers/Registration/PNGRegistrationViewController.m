//
//  PNGRegistrationViewController.m
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGRegistrationViewController.h"

@interface PNGRegistrationViewController ()

@end

@implementation PNGRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB Actions

//  Register button action.
- (IBAction)registerUser:(id)sender {
    if([self validateTextFields]) {
        PNGUser *user = [[PNGUser alloc] init];
        [self setUserDetails:user];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        registrationWebservice = [[PNGRegistrationWebservice alloc] init];
        [registrationWebservice userRegistration:user
                                        password:[PNGUtilities cleanString:passwordField.text]
                                requestSucceeded:^(PNGUser *user) {
                                    [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"")
                                                             message:NSLocalizedString(@"REGISTRATION_SUCCESS", @"")];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        } requestFailed:^(PNGUser *user, NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"")
                                     message:errorMsg];
        }];
    }
}

#pragma mark - Private methods

//  Validating required fields.
- (BOOL)validateTextFields {
    BOOL isValid = YES;
    if([PNGUtilities cleanString:firstNameField.text].length == 0) {
        isValid = NO;
        firstNameErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:firstNameContainer];
    } else {
        firstNameErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor whiteColor] forView:firstNameContainer];
    }
    if([PNGUtilities cleanString:lastNameField.text].length == 0) {
        isValid = NO;
        lastNameErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:lastNameContainer];
    } else {
        lastNameErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor whiteColor] forView:lastNameContainer];
    }
    isValid = [self performEmailValidation:isValid];
    isValid = [self performPasswordValidation:isValid];
    return isValid;
}

//  Checking password and confirm password field text length and their matching.
- (BOOL)performPasswordValidation:(BOOL)isValid {
    if([PNGUtilities cleanString:passwordField.text].length == 0) {
        isValid = NO;
        passwordErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:passwordContainer];
    } else {
        passwordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor whiteColor] forView:passwordContainer];
    }
    if([PNGUtilities cleanString:confirmPasswordField.text].length == 0) {
        isValid = NO;
        confirmPasswordErrorLabel.hidden = NO;
        confirmPasswordErrorLabel.text = NSLocalizedString(@"REQUIRED", @"");
        [PNGUtilities setBorderColor:[UIColor redColor] forView:confirmPasswordContainer];
    } else {
        confirmPasswordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor whiteColor] forView:confirmPasswordContainer];
        //  Password matching.
        if(![passwordField.text isEqualToString:confirmPasswordField.text]) {
            isValid = NO;
            confirmPasswordErrorLabel.hidden = NO;
            confirmPasswordErrorLabel.text = NSLocalizedString(@"PASSWORD_MUST_MATCH", @"");
            [PNGUtilities setBorderColor:[UIColor redColor] forView:confirmPasswordContainer];
            confirmPasswordField.text = nil;
            passwordField.text = nil;
            [passwordField becomeFirstResponder];
        } else {
            confirmPasswordErrorLabel.hidden = YES;
            [PNGUtilities setBorderColor:[UIColor whiteColor] forView:confirmPasswordContainer];
        }
    }
    return isValid;
}

//  Checking email field text length and email formats.
- (BOOL)performEmailValidation:(BOOL)isValid {
    if([PNGUtilities cleanString:emailField.text].length == 0) {
        isValid = NO;
        emailErrorLabel.hidden = NO;
        emailErrorLabel.text = NSLocalizedString(@"REQUIRED", @"");
        [PNGUtilities setBorderColor:[UIColor redColor] forView:emailContainer];
    } else {
        emailErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor whiteColor] forView:emailContainer];
        //  Email validation.
        if(![PNGUtilities isValidEmail:emailField.text]) {
            isValid = NO;
            emailErrorLabel.hidden = NO;
            emailErrorLabel.text = NSLocalizedString(@"INVALID_EMAIL", @"");
            [PNGUtilities setBorderColor:[UIColor redColor] forView:emailContainer];
        } else {
            emailErrorLabel.hidden = YES;
            [PNGUtilities setBorderColor:[UIColor whiteColor] forView:emailContainer];
        }
    }
    return isValid;
}

//  Setting user details to PFUser object.
- (void)setUserDetails:(PNGUser *)user {
//    user.username = emailField.text;
//    user.password = passwordField.text;
    user.email = emailField.text;
    user.firstName = firstNameField.text;
    user.lastName = lastNameField.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Notification methods

//  keyboard disappearing notification method.
- (void)keyboardWillHide:(NSNotification *)notification {
    scrollviewBottomSpace.constant = kZeroValue;
}

//  keyboard appearing notification method.
- (void)keyboardWillShow:(NSNotification *)notification {
    scrollviewBottomSpace.constant = kKeyboardHeight;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat y =  (textField.tag * textField.frame.size.height) - (self.view.frame.size.height - kNavBarHeight - kKeyboardHeight);
    if(y > 0)   //  Shift view only if the textfield is behind the keyboard.
        [contentScrollView setContentOffset:CGPointMake(0, y) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == firstNameField) {
        [lastNameField becomeFirstResponder];
    } else if (textField == lastNameField) {
        [emailField becomeFirstResponder];
    } else if (textField == emailField) {
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        [confirmPasswordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

@end

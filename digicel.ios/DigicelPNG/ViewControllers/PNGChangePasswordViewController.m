//
//  PNGChangePasswordViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGChangePasswordViewController.h"
#import "PNGUser.h"
#import "PNGChangePasswordWebservice.h"

@interface PNGChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordField;
@property (weak, nonatomic) IBOutlet UILabel *emailValidationLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordValidationLabel;

@end

@implementation PNGChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswordField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.confirmNewPasswordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - IBActions

//  Save new password
- (IBAction)tappedDoneButton:(id)sender {
    if ([self validAllFields]) {
        [self.view endEditing:YES];
        // calls the method to save new password.
        [self saveNewPasswordInParse];
    }
}

#pragma mark - Private Methods

// Method to perform validations
- (BOOL)validAllFields {
    BOOL isValid = YES;
    //  Checking old password field text length
    if([PNGUtilities cleanString:_oldPasswordField.text].length == 0) {
        isValid = NO;
        oldPasswordErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_oldPasswordField];
    } else {
        oldPasswordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_oldPasswordField];
    }
    //  Checking new password field text length
    if([PNGUtilities cleanString:_passwordField.text].length == 0) {
        isValid = NO;
        newPasswordErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_passwordField];
    } else {
        newPasswordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_passwordField];
    }
    //  Checking confirm password field text length
    if([PNGUtilities cleanString:_confirmNewPasswordField.text].length == 0) {
        isValid = NO;
        confirmPasswordErrorLabel.hidden = NO;
        confirmPasswordErrorLabel.text = NSLocalizedString(@"REQUIRED", @"");
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_confirmNewPasswordField];
    } else {
        confirmPasswordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_confirmNewPasswordField];
    }
    if(isValid) {
        //  Checking password mismatch.
        if([_passwordField.text isEqualToString:_confirmNewPasswordField.text]) {
            confirmPasswordErrorLabel.hidden = YES;
            [PNGUtilities setBorderColor:[UIColor clearColor] forView:_confirmNewPasswordField];
        } else {
            isValid = NO;
            confirmPasswordErrorLabel.hidden = NO;
            confirmPasswordErrorLabel.text = NSLocalizedString(@"PASSWORD_MUST_MATCH", @"");
            [PNGUtilities setBorderColor:[UIColor redColor] forView:_confirmNewPasswordField];
        }
    }
    return isValid;
}

// Method to save new password in Parse.
- (void)saveNewPasswordInParse {
    doneButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PNGChangePasswordWebservice *changePasswordWebservice = [[PNGChangePasswordWebservice alloc] init];
    [changePasswordWebservice changePassword:self.oldPasswordField.text newPassword:self.passwordField.text requestSucceeded:^(BOOL status) {
        doneButton.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"") message:NSLocalizedString(@"SAVE_SUCCESS", @"")];
        [self.navigationController popViewControllerAnimated:YES];
    }requestFailed:^(NSString *errorMsg) {
        doneButton.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
    }];
}

@end

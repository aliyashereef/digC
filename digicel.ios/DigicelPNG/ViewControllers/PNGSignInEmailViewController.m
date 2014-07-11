//
//  PNGSignInEmailViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSignInEmailViewController.h"
#import "PNGProfileViewController.h"
#import <Parse/Parse.h>

#define CONSTRAINT_WITH_KEYBOARD 12.0
#define CONSTRAINT_WITHOUT_KEYBOARD 48.0
#define LOGO_WIDTH_WITH_KEYBOARD 90.0
#define LOGO_WIDTH_WITHOUT_KEYBOARD 150.0
#define LOGO_WIDTH_THREEANDHALF_INCH 130.0
#define CONSTRAINT_THREEANDHALF_INCH 30.0

#define kResetPasswordAlertTag    1001

@interface PNGSignInEmailViewController () {
    IBOutlet NSLayoutConstraint *logoTopConstraint;
    IBOutlet NSLayoutConstraint *logoBottomConstraint;
    IBOutlet NSLayoutConstraint *signInButtonTopConstraint;
    IBOutlet NSLayoutConstraint *logoWidthConstraint;
    IBOutlet UILabel *emailErrorLabel;
    IBOutlet UILabel *passwordErrorLabel;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *doneButton;

@end

@implementation PNGSignInEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    [UIView animateWithDuration:kSignInViewAnimationDuration animations:^ {
        if (![PNGUtilities hasThreeAndHalfInchDisplay]) {
            logoTopConstraint.constant = CONSTRAINT_WITHOUT_KEYBOARD;
            logoBottomConstraint.constant = CONSTRAINT_WITHOUT_KEYBOARD;
            logoWidthConstraint.constant = LOGO_WIDTH_WITHOUT_KEYBOARD;
        }
        else {
            logoTopConstraint.constant = CONSTRAINT_THREEANDHALF_INCH;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    [UIView animateWithDuration:kSignInViewAnimationDuration animations:^ {
        
        if (![PNGUtilities hasThreeAndHalfInchDisplay]) {
            logoTopConstraint.constant = CONSTRAINT_WITH_KEYBOARD;
            logoBottomConstraint.constant = CONSTRAINT_WITH_KEYBOARD;
            logoWidthConstraint.constant = LOGO_WIDTH_WITH_KEYBOARD;
        } else {
            logoTopConstraint.constant = - LOGO_WIDTH_THREEANDHALF_INCH;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - IBActions

// Action for Sign In button
- (IBAction)tappedSignInButton:(id)sender {
    if([self validAllFields]) {
        // calls the method to login
        [self login];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//  Reset password, sends an email to the given email id for resetting password.
- (IBAction)resetPassword:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = NSLocalizedString(@"FORGOT_PASSWORD", @"");
    alertView.message = NSLocalizedString(@"ENTER_EMAIL_TO_RESET", @"");
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView addButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
    [alertView addButtonWithTitle:NSLocalizedString(@"DONE", @"")];
    alertView.delegate = self;
    alertView.tag = kResetPasswordAlertTag;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = _emailTextField.text;
    [alertView show];
}

#pragma mark - Private Methods

// Method to perform validations for email and password
- (BOOL)validAllFields {
    BOOL isValid = YES;
    if([PNGUtilities cleanString:self.emailTextField.text].length == kZeroValue) {
        isValid = NO;
        emailErrorLabel.hidden = NO;
        emailErrorLabel.text = NSLocalizedString(@"REQUIRED", @"");
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_emailView];
        [self.emailTextField becomeFirstResponder];
    } else {
        if([PNGUtilities isValidEmail:self.emailTextField.text]) {
            emailErrorLabel.hidden = YES;
            [PNGUtilities setBorderColor:[UIColor clearColor] forView:_emailView];
        } else {
            isValid = NO;
            emailErrorLabel.hidden = NO;
            emailErrorLabel.text = NSLocalizedString(@"INVALID_EMAIL", @"");
            [PNGUtilities setBorderColor:[UIColor redColor] forView:_emailView];
            [self.emailTextField becomeFirstResponder];
        }
    }
    if([PNGUtilities cleanString:self.passwordTextField.text].length == kZeroValue) {
        isValid = NO;
        passwordErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_passwordView];
    } else {
        passwordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_passwordView];
    }
    return isValid;
}

//  Validating email fields.
- (BOOL)validateEmail:(NSString *)email {
    BOOL isValid = YES;
    if([PNGUtilities cleanString:email].length == kZeroValue) {
        isValid = NO;
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:NSLocalizedString(@"ENTER_EMAIL_TO_RESET", @"")];
    } else {
        if(![PNGUtilities isValidEmail:email]) {
            isValid = NO;
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:NSLocalizedString(@"INVALID_EMAIL", @"")];
        }
    }
    return isValid;
}

// Method to login
- (void)login {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PNGLoginWebservice *loginWebservice = [[PNGLoginWebservice alloc] init];
    [loginWebservice userLogin:self.emailTextField.text password:self.passwordTextField.text requestSucceeded:^(PNGUser *user) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoggedInWithFacebook];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } requestFailed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
    }];
}


//Method to set view parameters
- (void)setViewParameters {
    if ([PNGUtilities hasThreeAndHalfInchDisplay]) {
        logoWidthConstraint.constant = LOGO_WIDTH_THREEANDHALF_INCH;
        logoTopConstraint.constant = CONSTRAINT_THREEANDHALF_INCH;
        logoBottomConstraint.constant = CONSTRAINT_THREEANDHALF_INCH;
    }
}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1 && alertView.tag == kResetPasswordAlertTag) {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        if([self validateEmail:alertTextField.text]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            PNGResetPasswordWebservice *resetPasswordWebservice = [[PNGResetPasswordWebservice alloc] init];
            [resetPasswordWebservice resetPasswordOfUser:alertTextField.text requestSucceeded:^(NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"") message:msg];
            } requestFailed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
            }];
        }
    }
}


@end

//
//  PNGEditProfileViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGEditProfileViewController.h"
#import "PNGUser.h"
#import "UIImageView+WebCache.h"

@interface PNGEditProfileViewController () {
    NSMutableArray *sources;
    UIImage *userSelectedProfileImage;
}

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageview;

@end

@implementation PNGEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Edit Profile";
    // calls the method to poulate user data
    [self populateViewWithUserData];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // Disable change password option for user logged in with Facebook
    return (![[NSUserDefaults standardUserDefaults] boolForKey:kLoggedInWithFacebook]);
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - ActionSheet Delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // if any option is selected from action sheet.
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = [[sources objectAtIndex:buttonIndex] integerValue];
        imagePicker.allowsEditing = YES;
        if(imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        [imagePicker setNavigationBarHidden:NO];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - ImagePickerController Delegate method

- (void)imagePickerController:(UIImagePickerController *)Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [Picker dismissViewControllerAnimated:YES completion:^{
        // set profile image here
        userSelectedProfileImage = image;
        [self.profileImageview setImage:image];
        [self.profileImageview setNeedsDisplay];
    }];
}

#pragma mark - IBActions

// Action for done button
- (IBAction)tappedDoneButton:(id)sender {
    if ([self validAllFields]) {
        [self.view endEditing:YES];
        // Calls the method to save the user object in Parse.
        [self updateProfile];
    }
}

// Action for profile image button
- (IBAction)tappedProfileImageButton:(id)sender {
    sources = [[NSMutableArray alloc] init];
    NSMutableArray *buttonTitles = [[NSMutableArray alloc] init];
    
    // checks whether camera is available.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [buttonTitles addObject:NSLocalizedString(@"TAKE_PHOTO", @"")];
    }
    // checks whether photo library is avaiable.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [buttonTitles addObject:NSLocalizedString(@"CHOOSE_FROM_LIBRARY", @"")];
    }
    
    if ([sources count]) {
        // adds the available image sources to actionsheet.
        UIActionSheet *actionSheets = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString *title in buttonTitles)
            [actionSheets addButtonWithTitle:title];
        [actionSheets addButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
        actionSheets.cancelButtonIndex = sources.count;
        [actionSheets showFromRect:[sender frame] inView:self.view animated:YES];
    }
}

#pragma mark - Private Methods

// Populates all the text fields with the user data.
- (void)populateViewWithUserData {
    PNGUser *currentUser = [APP_DELEGATE loggedInUser];
    self.firstNameTextField.text = currentUser.firstName;
    self.lastNameTextField.text = currentUser.lastName;
    self.emailTextField.text = currentUser.email;
    
    // Calls the method to set up the profile image view.
    [self setUpProfileImageView];
    // sets the user display picture.
    if(currentUser.avatar != nil) {
        [self.profileImageview setImageWithURL:[NSURL URLWithString:currentUser.avatar]
                              placeholderImage:[UIImage imageNamed:PNGStoryboardProfilePlaceholder]];
//        self.profileImageview.image = [self.profileImageview.image roundedCornerImage:300 borderSize:10];
    } else {
        self.profileImageview.image = [UIImage imageNamed:PNGStoryboardProfilePlaceholder];
    }
}

// Method to set up the profile image view.
- (void)setUpProfileImageView {
    self.profileImageview.layer.cornerRadius=53;
    self.profileImageview.layer.borderWidth=2;
    self.profileImageview.layer.borderColor=[UIColor whiteColor].CGColor;
    self.profileImageview.clipsToBounds=YES;
}

// Method to perform validations
- (BOOL)validAllFields {
    BOOL isValid = YES;
    //  checking first name
    if(![PNGUtilities isValidAlphaNumericString:self.firstNameTextField.text]) {
        isValid = NO;
        firstNameErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_firstNameTextField];
    } else {
        firstNameErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_firstNameTextField];
    }
    //  checking last name
    if(![PNGUtilities isValidAlphaNumericString:self.lastNameTextField.text]) {
        isValid = NO;
        lastNameErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_lastNameTextField];
    } else {
        lastNameErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_lastNameTextField];
    }
    //  checking email address
    if([PNGUtilities cleanString:self.emailTextField.text].length == 0) {
        isValid = NO;
        emailErrorLabel.hidden = NO;
        emailErrorLabel.text = NSLocalizedString(@"REQUIRED", @"");
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_emailTextField];
    } else {
        //  checking email format
        if(![PNGUtilities isValidEmail:self.emailTextField.text]) {
            isValid = NO;
            emailErrorLabel.hidden = NO;
            emailErrorLabel.text = NSLocalizedString(@"INVALID_EMAIL", @"");
            [PNGUtilities setBorderColor:[UIColor redColor] forView:_emailTextField];
        } else {
            emailErrorLabel.hidden = YES;
            [PNGUtilities setBorderColor:[UIColor clearColor] forView:_emailTextField];
        }
    }
    return isValid;
}

//  Setting user details to PFUser object.
- (void)setUserDetails:(PNGUser *)user {
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.email = self.emailTextField.text;
}

// Set user details and save it in Parse
- (void)updateProfile {
    PNGUser *user = [APP_DELEGATE loggedInUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setUserDetails:user];
    PNGEditProfileWebservice *editProfileWebservice = [[PNGEditProfileWebservice alloc] init];
    [editProfileWebservice editProfileOfUser:user requestSucceeded:^(PNGUser *user) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"") message:NSLocalizedString(@"SAVE_SUCCESS", @"")];
        [self.navigationController popViewControllerAnimated:YES];
    } requestFailed:^(PNGUser *user, NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:NSLocalizedString(@"SAVE_FAIL", @"")];
    }];
}

@end

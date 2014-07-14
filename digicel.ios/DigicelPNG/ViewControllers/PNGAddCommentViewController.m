//
//  PNGAddCommentViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGAddCommentViewController.h"

static int const PostSuccessAlertTag = 101;

@interface PNGAddCommentViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@end

@implementation PNGAddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.parentCommentId) {
        self.title = @"Add a Reply";
    }
    [self.commentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method to perform validations for email and password
- (BOOL)isValidComment {
    BOOL isValid = YES;
    
    if ([PNGUtilities cleanString:self.commentTextView.text].length == kZeroValue) {
        isValid = NO;
        self.commentErrorLabel.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:self.commentView];
    } else {
        self.commentErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:self.commentView];
    }
    return isValid;
}

- (IBAction)doneButtonTapped:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy HH mm ss"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTimeString= [dateFormat stringFromDate:currentTime];
    if([[NSUserDefaults standardUserDefaults] valueForKey:kLastCommentTime]){
        NSString *commentTimestring=[[NSUserDefaults standardUserDefaults] valueForKey: kLastCommentTime];
        NSDate *commentTime=[dateFormat dateFromString:commentTimestring];
        NSTimeInterval timeDifference = [currentTime timeIntervalSinceDate:commentTime];
       if (timeDifference<120){
            [PNGUtilities showAlertWithTitle:@"SORRY" message:@"wait for some time"];
        }else{
            [self addComment];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:currentTimeString forKey:kLastCommentTime];
            [defaults synchronize];
        }}
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:currentTimeString forKey:kLastCommentTime];
        [defaults synchronize];
        [self addComment];
    }
}

//Add comment succes alert
- (void)showSuccessAlert {
    UIAlertView *succesAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"COMMENT_SUBMIT_SUCCESS", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"DISMISS", @"") otherButtonTitles:nil];
    succesAlert.tag = PostSuccessAlertTag;
    [succesAlert show];
}

#pragma mark - UIAlertview delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   //Submit comment succes alert
    if (alertView.tag == PostSuccessAlertTag) {
        //Dismiss view
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TextView delegate

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.commentErrorLabel.hidden) {
        self.commentErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:self.commentView];
    }
}

#pragma mark - Function
-(void)addComment
{
    if ([self isValidComment]) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self.commentTextView resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        PNGAddCommentWebService *addCommentWebService = [[PNGAddCommentWebService alloc] init];
        
        if (self.parentCommentId) {
            [addCommentWebService addReply:self.commentTextView.text forCommentId:self.parentCommentId forPostId:self.postId requestSucceeded:^(void) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showSuccessAlert];
            } requestFailed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
            }];
        } else {
            [addCommentWebService addComment:self.commentTextView.text forPostId:self.postId requestSucceeded:^(void) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showSuccessAlert];
            } requestFailed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
            }];
        }
    }

}
@end

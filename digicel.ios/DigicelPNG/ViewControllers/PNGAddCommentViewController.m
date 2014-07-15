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

#pragma mark - Methods
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


//Method to check whether required time to post a comment elapsed.
- (BOOL)isTimeToPostComment{
    BOOL isTimeToPostComment = NO;
    NSString *commentTimestring=[[NSUserDefaults standardUserDefaults] valueForKey: kLastCommentTime];
    NSDate *commentTime=[PNGUtilities getDateFromDateString:commentTimestring];
    NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:commentTime];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kLastCommentTime]) {
        if (timeDifference>kCommentInterval){
            isTimeToPostComment = YES;
        }else{
            isTimeToPostComment = NO;
        }
    }else{
        isTimeToPostComment = YES;
    }
    return isTimeToPostComment;
}

// To add a comment.
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
                [self setLastCommentTime];
            } requestFailed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
            }];
        } else {
            [addCommentWebService addComment:self.commentTextView.text forPostId:self.postId requestSucceeded:^(void) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showSuccessAlert];
                [self setLastCommentTime];
            } requestFailed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
            }];
        }
    }
    
}
//Add comment succes alert
- (void)showSuccessAlert {
    UIAlertView *succesAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"COMMENT_SUBMIT_SUCCESS", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"DISMISS", @"") otherButtonTitles:nil];
    succesAlert.tag = PostSuccessAlertTag;
    [succesAlert show];
}

//Setting the last comment posting time in the user defaults.

- (void)setLastCommentTime{
    NSString *currentTimeString= [PNGUtilities getDateStringFromDate:[NSDate date]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:currentTimeString forKey:kLastCommentTime];
    [defaults synchronize];
}


#pragma mark - IB Actions

- (IBAction)doneButtonTapped:(id)sender {
    if ([self isTimeToPostComment]) {
            [self addComment];
    }else{
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SLOWDOWN_COMMENT_TIME", @"") message:nil];
    }
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

@end

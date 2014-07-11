//
//  PNGSignInViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSignInViewController.h"
#import "PNGEditProfileViewController.h"
#import "MBProgressHUD.h"
#import "PNGUser.h"
#import <Parse/Parse.h>

@interface PNGSignInViewController ()

@end

@implementation PNGSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PNGStoryboardSegueToRegister]) {
        [(PNGEditProfileViewController *)segue.destinationViewController setRegistration:YES];
    }
}

#pragma mark - Private methods

- (void)signInusingFBAccessToken:(NSString *)token {
    [self performSelectorOnMainThread:@selector(showProgressHUDInMainThread) withObject:nil waitUntilDone:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@api/user/fb_user_connect/?access_token=%@",kBaseUrl,token]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if([[responseObject valueForKey:@"status"] isEqualToString:@"ok"]) {
              PNGUser *user = [PNGUser createUserFromDictionary:[responseObject valueForKey:@"user"]];
              NSDictionary *userInfo = [user getUserDictionary];
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              [defaults setObject:[responseObject valueForKey:@"cookie"] forKey:kAuthCookie];
              [defaults setObject:userInfo forKey:kUserInfo];
              [defaults setBool:YES forKey:kLoginStatus];
              [defaults setBool:YES forKey:kLoggedInWithFacebook];
              [defaults synchronize];
              [self dismissViewControllerAnimated:YES completion:nil];
          } else {
              [PNGUtilities showAlertWithTitle:@"Failed" message:[responseObject valueForKey:@"error"]];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error : %@",error.localizedDescription);
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          [PNGUtilities showAlertWithTitle:@"Failed" message:error.localizedDescription];
      }];
}


#pragma mark - IBActions

- (IBAction)dismissViewController:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//  Sign in using facebook. First checking for accounts configured in settings app.
//  If its not available fb dialogue opens to login into the fb.
- (IBAction)signInWithFacebook:(id)sender {
    NSArray *permissions = @[@"email"];
    NSDictionary *options = @{ACFacebookAppIdKey:FACEBOOK_APP_ID,
                              ACFacebookPermissionsKey:permissions,
                              ACFacebookAudienceFriends:ACFacebookAudienceKey};
    
    // Initialize the account store
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    // Get the Facebook account type for the access request
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // If access granted, then get the Facebook account info
            NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
            ACAccount *fbAccount = [accounts lastObject];
            
            // Get the access token, could be used in other scenarios
            ACAccountCredential *fbCredential = [fbAccount credential];
            NSString *accessToken = [fbCredential oauthToken];
            
            if (accessToken) {
                [self signInusingFBAccessToken:accessToken];
            } else {
                [self performSelectorOnMainThread:@selector(showAlertInMainThread:)
                                       withObject:@"Unable to login, please try again later"
                                    waitUntilDone:NO];
            }
        } else {
            if ([error code] == ACErrorAccountNotFound) {
                // User has not logged in to Facebook in the Settings app
                [self performSelectorOnMainThread:@selector(showAlertInMainThread:)
                                       withObject:@"Please configure your facebook account in settings app and try again"
                                    waitUntilDone:NO];
            } else {
                // User rejected permission to the app
                [self performSelectorOnMainThread:@selector(showAlertInMainThread:)
                                       withObject:@"Please grant access to your Facebook account for PNG Loop by enabling it in Settings > Facebook"
                                    waitUntilDone:NO];
            }
        }
    }];
}

//  Sbows alert message in main thread.
- (void)showAlertInMainThread:(NSString *)message {
    [PNGUtilities showAlertWithTitle:@"Failed" message:message];
}

- (void)showProgressHUDInMainThread {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

@end

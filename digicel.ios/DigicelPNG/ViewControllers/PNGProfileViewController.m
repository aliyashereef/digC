//
//  PNGProfileViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "PNGClassifiedsViewController.h"

@interface PNGProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation PNGProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUserDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

//  upadate UI with logged in user details.
- (void)setUserDetails {
    PNGUser *user = [APP_DELEGATE loggedInUser];
    self.nameLabel.text = user.displayname;
    self.emailLabel.text = user.email;
    
    // calls the method to set up the profile image view.
    [self setUpProfileImageView];
    
    // sets the user display picture.
    if(user.avatar != nil) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:PNGStoryboardProfilePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            self.userImageView.image = [self.userImageView.image roundedCornerImage:300 borderSize:10];
        }];
    } else {
        self.userImageView.image = [UIImage imageNamed:PNGStoryboardProfilePlaceholder];
    }
}

// set up the profile image view.
- (void)setUpProfileImageView {
    self.userImageView.layer.cornerRadius=60;
    self.userImageView.layer.borderWidth=2;
    self.userImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.userImageView.clipsToBounds=YES;
}

#pragma mark - IBActions

- (IBAction)dismissViewController:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end

//
//  PNGFullScreenViewController.m
//  DigicelPNG
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGFullScreenViewController.h"

@interface PNGFullScreenViewController ()

@end

@implementation PNGFullScreenViewController

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
    [self.fullScreenImageView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)DoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

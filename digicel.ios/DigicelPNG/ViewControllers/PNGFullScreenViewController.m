//
//  PNGFullScreenViewController.m
//  DigicelPNG
//
//  Created by Subins Jose on 31/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGFullScreenViewController.h"
#import "UIImageView+WebCache.h"


@interface PNGFullScreenViewController ()   

@end

@implementation PNGFullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fullScreenImageView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _fullScreenImageView;
}

- (IBAction)DoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end

//
//  PNGFullScreenViewController.h
//  DigicelPNG
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface PNGFullScreenViewController : UIViewController
@property (nonatomic,strong) NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;
- (IBAction)DoneButton:(id)sender;


@end
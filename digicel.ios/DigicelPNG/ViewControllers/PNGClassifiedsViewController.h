//
//  PNGClassifiedsViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PNGClassifiedsViewController : GAITrackedViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *url;

@end

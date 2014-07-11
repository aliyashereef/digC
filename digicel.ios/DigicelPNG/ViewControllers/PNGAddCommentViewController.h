//
//  PNGAddCommentViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGAddCommentWebService.h"

@interface PNGAddCommentViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *parentCommentId;

@end

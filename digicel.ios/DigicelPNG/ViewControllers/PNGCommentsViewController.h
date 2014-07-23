//
//  PNGCommentsViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGCommentCell.h"
#import "PNGCommentReplyCell.h"
#import "GAITrackedViewController.h"

@interface PNGCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PNGCommentCellDelegate>

@property (nonatomic, strong) NSString *postId;

@end

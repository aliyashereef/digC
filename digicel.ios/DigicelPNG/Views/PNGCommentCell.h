//
//  PNGCommentCell.h
//  DigicelPNG
//
//  Created by Anand V on 04/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGLatoLabel.h"
#import "PNGComment.h"
#import "PNGUser.h"

@protocol PNGCommentCellDelegate <NSObject>

- (void)replyButtonSelectedForCommentAtIndex:(NSInteger)index;
- (void)shareButtonSelectedForCommentWithText:(NSString *)text;

@end

/*
 Custom table view cell for comments added to articles
 */

@interface PNGCommentCell : UITableViewCell {
    IBOutlet PNGLatoLabel *usernameInitialsLabel;
    IBOutlet UIImageView *usernameInitialsBackgroundImageView;
    
    IBOutlet PNGLatoLabel *usernameLabel;
    IBOutlet PNGLatoLabel *commentTextLabel;
    
    IBOutlet UIImageView *commentPointerImageView;
    
    IBOutlet NSLayoutConstraint *initialsViewLeadingSpace;
    IBOutlet NSLayoutConstraint *commentViewTrailingSpace;
    IBOutlet NSLayoutConstraint *commentPointerImageViewLeadingSpace;
    
    IBOutlet NSLayoutConstraint *moreOptionsViewHeight;
}

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) PNGComment *comment;

@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong) id <PNGCommentCellDelegate> delegate;

@end

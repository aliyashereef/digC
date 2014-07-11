//
//  PNGCommentCell.m
//  DigicelPNG
//
//  Created by Anand V on 04/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGCommentCell.h"

#define kInitialsViewLeadingSpaceAlignedLeft 0
#define kInitialsViewLeadingSpaceAlignedRight 256

#define kCommentViewTrailingSpaceAlignedLeft 0
#define kCommentViewTrailingSpaceAlignedRight 53

#define kCommentPointerImageViewLeadingSpaceAlignedLeft 46
#define kCommentPointerImageViewLeadingSpaceAlignedRight 243

#define kCommentPointerImageViewTransformAngleLeft 0
#define kCommentPointerImageViewTransformAngleRight M_PI

#define kMoreOptionsViewVisibleHeight 30
#define kMoreOptionsViewHiddenHeight 0

#define kCommentLabelLinesNormalCount 5
#define kCommentLabelLinesExpandedCount 0

#define kLoggedInUserCommentImage @"user-comment-initials-bg"
#define kOtherUserCommentImage @"other-comment-initials-bg"

@implementation PNGCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    if (index % 2) {                                    // Right aligned comment
        initialsViewLeadingSpace.constant = kInitialsViewLeadingSpaceAlignedRight;
        commentViewTrailingSpace.constant = kCommentViewTrailingSpaceAlignedRight;
        commentPointerImageViewLeadingSpace.constant = kCommentPointerImageViewLeadingSpaceAlignedRight;
        commentPointerImageView.transform = CGAffineTransformMakeRotation(kCommentPointerImageViewTransformAngleRight);
    } else {
        initialsViewLeadingSpace.constant = kInitialsViewLeadingSpaceAlignedLeft;
        commentViewTrailingSpace.constant = kCommentViewTrailingSpaceAlignedLeft;
        commentPointerImageViewLeadingSpace.constant = kCommentPointerImageViewLeadingSpaceAlignedLeft;
        commentPointerImageView.transform = CGAffineTransformMakeRotation(kCommentPointerImageViewTransformAngleLeft);
    }
    moreOptionsViewHeight.constant = kMoreOptionsViewHiddenHeight;      // Initially more options view is hidden.
}

- (void)setUsernameLabelsTextForComment:(PNGComment *)comment {
    NSString *userInitialsText = @"AN";
    NSString *username = @"Anonymous";
    
    // Extracting username initials from first name and last name or from name field if the first two are not there.
    if (comment.authorFirstName && ![comment.authorFirstName isEqualToString:@""]) {
        userInitialsText = [[NSString stringWithFormat:@"%@%@", [comment.authorFirstName substringToIndex:1], [comment.authorLastName substringToIndex:1]] uppercaseString];
        username = [NSString stringWithFormat:@"%@ %@", comment.authorFirstName, comment.authorLastName];
    } else if (comment.authorName  && ![comment.authorName isEqualToString:@""]) {
        if ([comment.authorName rangeOfString:@" "].location == NSNotFound) {
            if (comment.authorName.length > 1) {
                userInitialsText = [[comment.authorName substringToIndex:2] uppercaseString];
            } else {
                userInitialsText = [comment.authorName uppercaseString];
            }
        } else {
            NSRange range = [comment.authorName rangeOfString:@" " options:NSBackwardsSearch];  // For extracting initials from name field if it has both first and last names combined.
            range.location += 1;
            userInitialsText = [NSString stringWithFormat:@"%@%@", [comment.authorName substringToIndex:1], [comment.authorName substringWithRange:range]];
        }
        username = comment.authorName;
    } else if (comment.name && ![comment.name isEqualToString:@""]) {
        if ([comment.name rangeOfString:@" "].location == NSNotFound) {
            if (comment.name.length > 1) {
                userInitialsText = [[comment.name substringToIndex:2] uppercaseString];
            } else {
                userInitialsText = [comment.name uppercaseString];
            }
        } else {
            NSRange range = [comment.name rangeOfString:@" " options:NSBackwardsSearch];    // For extracting initials from name field if it has both first and last names combined.
            range.location += 1;
            userInitialsText = [NSString stringWithFormat:@"%@%@", [comment.name substringToIndex:1], [comment.name substringWithRange:range]];
        }
        username = comment.name;
    }
    
    usernameInitialsLabel.text = userInitialsText;
    usernameLabel.text = username;
}

- (void)setComment:(PNGComment *)comment {
    _comment = comment;
    
    [self setUsernameLabelsTextForComment:comment];
    
    // Expand the cell on touch to show more options buttons, replies to the comment and more text (if any).
    if (self.isExpanded) {
        commentTextLabel.numberOfLines = kCommentLabelLinesExpandedCount;
        moreOptionsViewHeight.constant = kMoreOptionsViewVisibleHeight;
    } else {
        commentTextLabel.numberOfLines = kCommentLabelLinesNormalCount;
        moreOptionsViewHeight.constant = kMoreOptionsViewHiddenHeight;
    }
    commentTextLabel.text = comment.content;
    
    PNGUser *user = [APP_DELEGATE loggedInUser];
    // Logged in user's comment view has different name initials view background.
    if (user) {
        if (comment.commentAuthorId && [user.userId isEqual:comment.commentAuthorId]) {
            usernameInitialsBackgroundImageView.image = [UIImage imageNamed:kLoggedInUserCommentImage];
        } else {
            usernameInitialsBackgroundImageView.image = [UIImage imageNamed:kOtherUserCommentImage];
        }
    } else {
        usernameInitialsBackgroundImageView.image = [UIImage imageNamed:kOtherUserCommentImage];
    }
}

- (IBAction)replyButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyButtonSelectedForCommentAtIndex:)]) {
        [self.delegate replyButtonSelectedForCommentAtIndex:self.index];
    }
}

- (IBAction)shareButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonSelectedForCommentWithText:)]) {
        [self.delegate shareButtonSelectedForCommentWithText:self.comment.content];
    }
}

@end

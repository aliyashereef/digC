//
//  PNGCommentReplyCell.m
//  DigicelPNG
//
//  Created by Anand V on 26/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGCommentReplyCell.h"

#define kMoreOptionsViewVisibleHeight 30
#define kMoreOptionsViewHiddenHeight 0

#define kCommentLabelLinesNormalCount 5
#define kCommentLabelLinesExpandedCount 0

@implementation PNGCommentReplyCell

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

- (void)setUsernameLabelTextForComment:(PNGComment *)comment {
    NSString *username = @"Anonymous";
    
    // Extracting username initials from first name and last name or from name field if the first two are not there.
    if (comment.authorFirstName && ![comment.authorFirstName isEqualToString:@""]) {
        username = [NSString stringWithFormat:@"%@ %@", comment.authorFirstName, comment.authorLastName];
    } else if (comment.authorName  && ![comment.authorName isEqualToString:@""]) {
        username = comment.authorName;
    } else if (comment.name && ![comment.name isEqualToString:@""]) {
        username = comment.name;
    }
    
    usernameLabel.text = username;
}

- (void)setReply:(PNGComment *)reply {
    _reply = reply;
    
    [self setUsernameLabelTextForComment:reply];
    
    // Expand the cell on touch to show more options buttons, replies to the comment and more text (if any).
    if (self.isExpanded) {
        commentTextLabel.numberOfLines = kCommentLabelLinesExpandedCount;
        moreOptionsViewHeight.constant = kMoreOptionsViewVisibleHeight;
    } else {
        commentTextLabel.numberOfLines = kCommentLabelLinesNormalCount;
        moreOptionsViewHeight.constant = kMoreOptionsViewHiddenHeight;
    }
    commentTextLabel.text = reply.content;
}

- (IBAction)shareButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonSelectedForCommentWithText:)]) {
        [self.delegate shareButtonSelectedForCommentWithText:self.reply.content];
    }
}

@end

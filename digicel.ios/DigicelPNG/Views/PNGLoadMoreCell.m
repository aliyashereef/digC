//
//  PNGLoadMoreCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 13/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGLoadMoreCell.h"

#define kCenterAlignedCellLeadingSpaceConstraint 12
#define kLeftAlignedCellLeadingSpaceConstraint 12
#define kRightAlignedCellLeadingSpaceConstraint 65

#define kCenteredCellWidth 296
#define kSideAlignedCellWidth 243

@implementation PNGLoadMoreCell

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

- (void)setCellAlignment:(CellAlignment)cellAlignment {
    _cellAlignment = cellAlignment;
    
    if (cellAlignment == Centered) {
        leadingSpaceConstraint.constant = kCenterAlignedCellLeadingSpaceConstraint;
        widthConstraint.constant = 296;
    } else if (cellAlignment == Left) {
        leadingSpaceConstraint.constant = 12;
        widthConstraint.constant = 243;
    } else {
        leadingSpaceConstraint.constant = 65;
        widthConstraint.constant = 243;
    }
}

@end

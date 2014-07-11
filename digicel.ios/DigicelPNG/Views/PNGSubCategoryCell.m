//
//  PNGSubCategoryCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 02/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSubCategoryCell.h"

@implementation PNGSubCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        self.tickView.hidden = NO;
        self.titleLabel.textColor = kThemeGreen;
    } else {
        self.tickView.hidden = YES;
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted) {
        self.tickView.hidden = NO;
        self.titleLabel.textColor = kThemeGreen;
    } else {
        self.tickView.hidden = YES;
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end

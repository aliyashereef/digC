//
//  PNGMenuTableViewCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGMenuTableViewCell.h"

@implementation PNGMenuTableViewCell

- (void)awakeFromNib {
    titleLabelSpacing.constant = 15;
    _iconView.hidden = YES;
}

- (void)setMenuItem:(NSDictionary *)menuItem {
    _menuItem = menuItem;
    if(menuItem == nil) {
        titleLabelSpacing.constant = 15;
        _iconView.hidden = YES;
    } else {
        _menuTitleLabel.text = [menuItem valueForKey:@"title"];
        if([_menuItem valueForKey:@"image"]) {
            _iconView.image = [UIImage imageNamed:[_menuItem valueForKey:@"image"]];
            titleLabelSpacing.constant = 42;
            _iconView.hidden = NO;
            _menuTitleLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            titleLabelSpacing.constant = 15;
            _iconView.hidden = YES;
            _menuTitleLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        if([_menuItem valueForKey:@"categoryId"]) {
            self.backgroundColor = [PNGUtilities getColorForCategoryItem:[[_menuItem valueForKey:@"categoryId"] intValue]];
        } else {
            self.backgroundColor = kThemeGreen;
        }
        _menuTitleLabel.textColor = [UIColor whiteColor];
        if([_menuItem valueForKey:@"image_selected"]) {
            _iconView.image = [UIImage imageNamed:[_menuItem valueForKey:@"image_selected"]];
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
        _menuTitleLabel.textColor = kMenuDefaultColor;
        if([_menuItem valueForKey:@"image"]) {
            _iconView.image = [UIImage imageNamed:[_menuItem valueForKey:@"image"]];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted) {
        if([_menuItem valueForKey:@"categoryId"]) {
            self.backgroundColor = [PNGUtilities getColorForCategoryItem:[[_menuItem valueForKey:@"categoryId"] intValue]];
        } else {
            self.backgroundColor = kThemeGreen;
        }
        _menuTitleLabel.textColor = [UIColor whiteColor];
        if([_menuItem valueForKey:@"image_selected"]) {
            _iconView.image = [UIImage imageNamed:[_menuItem valueForKey:@"image_selected"]];
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
        _menuTitleLabel.textColor = kMenuDefaultColor;
        if([_menuItem valueForKey:@"image"]) {
            _iconView.image = [UIImage imageNamed:[_menuItem valueForKey:@"image"]];
        }
    }
}

@end

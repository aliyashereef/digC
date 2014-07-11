//
//  PNGMenuTableViewCell.h
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGLatoLabel.h"

/*
 Table view cell for home view menu table.
 */

@interface PNGMenuTableViewCell : UITableViewCell {
    
    
    IBOutlet NSLayoutConstraint *titleLabelSpacing;
}

@property (nonatomic, strong) IBOutlet UILabel *menuTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) NSDictionary *menuItem;

@end

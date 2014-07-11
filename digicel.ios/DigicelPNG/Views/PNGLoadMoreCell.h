//
//  PNGLoadMoreCell.h
//  DigicelPNG
//
//  Created by Arundev K S on 13/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Centered,
    Left,
    Right
} CellAlignment;

@interface PNGLoadMoreCell : UITableViewCell {
    IBOutlet NSLayoutConstraint *leadingSpaceConstraint;
    IBOutlet NSLayoutConstraint *widthConstraint;
}

@property (nonatomic, strong) IBOutlet UIButton *loadMoreButton;
@property (nonatomic, strong) IBOutlet UILabel *loadMoreTextLabel;
@property (nonatomic) CellAlignment cellAlignment;

@end

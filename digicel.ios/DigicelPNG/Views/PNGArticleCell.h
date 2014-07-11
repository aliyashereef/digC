//
//  PNGArticleCell.h
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGArticle.h"
#import "UIImageView+WebCache.h"

/*
 Table view cell, used for listing articles. Contains an image view and a label.
 */

@interface PNGArticleCell : UITableViewCell {
    
    IBOutlet UIImageView *articleImageView;
    IBOutlet UILabel *articleTitleLabel;
}

@property (nonatomic, strong) PNGArticle *article;

@end

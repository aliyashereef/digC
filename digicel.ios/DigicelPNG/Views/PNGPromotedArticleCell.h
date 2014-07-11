//
//  PNGPromotedArticleCell.h
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGArticle.h"
#import "UIImageView+WebCache.h"
#import "PNGArticleCell.h"

@interface PNGPromotedArticleCell : PNGArticleCell {
    
    IBOutlet UIImageView *secondArticleImageView;
    IBOutlet UILabel *secondArticleTitleLabel;
}

@property (nonatomic, strong) PNGArticle *secondArticle;
@property (nonatomic, strong) IBOutlet UIView *secondArticleContainer;

@end

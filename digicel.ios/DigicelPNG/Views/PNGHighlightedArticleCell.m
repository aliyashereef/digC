//
//  PNGHighlightedArticleCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGHighlightedArticleCell.h"

#define kTitleViewSingleLineHeight  80
#define kTitleViewTwoLineHeight     110

@implementation PNGHighlightedArticleCell

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

- (void)setArticle:(PNGArticle *)article {
    [super setArticle:article];
    if (self.parent == ARTICLES){
    [articleImageView setImageWithURL:[NSURL URLWithString:article.postImageURL]
                     placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleFeatured]];
        CGSize reqSize = [PNGUtilities getRequiredSizeForText:article.title
                                                         font:[UIFont fontWithName:@"Lato-Bold" size:24]
                                                     maxWidth:articleTitleLabel.frame.size.width];
        //  Calculating required height for the title label.
        if(reqSize.height > 30) {
            titleViewHeight.constant = kTitleViewTwoLineHeight;
        } else {
            titleViewHeight.constant = kTitleViewSingleLineHeight;
        }
    }else{
        
        NSArray *images = [article valueForKey:@"ad_images"];
        
        if(images && [images count] > 0) {
            NSDictionary *imageDict = [images firstObject];
            NSString *imagePath     = [imageDict valueForKey:@"path"];
            [articleImageView setImageWithURL:[NSURL URLWithString:imagePath]
                             placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
            CGSize reqSize = [PNGUtilities getRequiredSizeForText:[imageDict valueForKey:@"path"]
                                                         font:[UIFont fontWithName:@"Lato-Bold" size:24]
                                                     maxWidth:articleTitleLabel.frame.size.width];
        //  Calculating required height for the title label.
            if(reqSize.height > 30) {
                titleViewHeight.constant = kTitleViewTwoLineHeight;
            } else {
                titleViewHeight.constant = kTitleViewSingleLineHeight;
            }
        }
    }
}

@end

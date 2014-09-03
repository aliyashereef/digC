//
//  PNGPromotedArticleCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGPromotedArticleCell.h"

@implementation PNGPromotedArticleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//  Setter method for article
- (void)setSecondArticle:(PNGArticle *)secondArticle {
    _secondArticle = secondArticle;
    if ( self.parent == [NSNumber numberWithInt:1]){
        secondArticleTitleLabel.text = secondArticle.title;
        [secondArticleImageView setImageWithURL:[NSURL URLWithString:secondArticle.thumbNailImageUrl]
                           placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleColumn]];
    }else{
        secondArticleTitleLabel.text = [secondArticle valueForKey:@"ad_title"];
        
        NSArray *images = [secondArticle valueForKey:@"ad_images"];
        
        if(images && [images count] > 0) {
            NSDictionary *imageDict = [images firstObject];
            NSString *imagePath     = [imageDict valueForKey:@"path"];
            [secondArticleImageView setImageWithURL:[NSURL URLWithString:imagePath]
                             placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
        }
    }

}

@end

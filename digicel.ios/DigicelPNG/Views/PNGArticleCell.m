//
//  PNGArticleCell.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticleCell.h"

@implementation PNGArticleCell

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
- (void)setArticle:(PNGArticle *)article{
    _article = article;
    if ( _parent == [NSNumber numberWithInt:1]){
        articleTitleLabel.text = article.title;
        [articleImageView setImageWithURL:[NSURL URLWithString:article.thumbNailImageUrl]
                     placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
    }else{
        articleTitleLabel.text = [article valueForKey:@"ad_category"];
        [articleImageView setImageWithURL:[NSURL URLWithString:[[[article valueForKey:@"ad_images"] objectAtIndex:0] valueForKey:@"path"]]
                         placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
    }
}

@end

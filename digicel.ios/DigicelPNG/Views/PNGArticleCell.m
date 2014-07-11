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
- (void)setArticle:(PNGArticle *)article {
    _article = article;
    articleTitleLabel.text = article.title;
    [articleImageView setImageWithURL:[NSURL URLWithString:article.thumbNailImageUrl]
                     placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleList]];
}

@end

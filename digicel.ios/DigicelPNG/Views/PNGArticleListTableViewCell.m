//
//  PNGArticleListTableViewCell.m
//  DigicelPNG
//
//  Created by Shane Henderson on 18/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticleListTableViewCell.h"

@interface PNGArticleListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionTextField;

@end

@implementation PNGArticleListTableViewCell

#pragma mark - Properties

- (NSString *)detailText
{
    return self.descriptionTextField.text;
}

- (void)setDetailText:(NSString *)text
{
    self.descriptionTextField.text = text;
}

@end

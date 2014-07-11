//
//  PNGLatoButton.m
//  DigicelPNG
//
//  Created by Arundev K S on 22/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGLatoButton.h"

@implementation PNGLatoButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIFontDescriptor *fontDescriptor = self.titleLabel.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    NSString *fontName = (isBold?@"Lato-Bold":@"Lato-Regular");
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end

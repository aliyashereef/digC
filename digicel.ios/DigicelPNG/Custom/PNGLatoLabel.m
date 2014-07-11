//
//  PNGLatoLabel.m
//  DigicelPNG
//
//  Created by Arundev K S on 22/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGLatoLabel.h"

@implementation PNGLatoLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIFontDescriptor *fontDescriptor = self.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    NSString *fontName = (isBold?@"Lato-Bold":@"Lato-Regular");
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

- (void)setFontSize:(CGFloat)fontSize {
    UIFontDescriptor *fontDescriptor = self.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    NSString *fontName = (isBold?@"Lato-Bold":@"Lato-Regular");
    self.font = [UIFont fontWithName:fontName size:fontSize];
}

@end

//
//  PNGLatoTextField.m
//  DigicelPNG
//
//  Created by Srijith on 22/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGLatoTextField.h"

@implementation PNGLatoTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.textColor = [UIColor whiteColor];
//        [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 8;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 8;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (void)awakeFromNib {
    UIFontDescriptor *fontDescriptor = self.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    NSString *fontName = (isBold?@"Lato-Bold":@"Lato-Regular");
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
//    self.textColor = [UIColor whiteColor];
//    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

@end

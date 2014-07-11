//
//  NSString+PNGString.m
//  DigicelPNG
//
//  Created by Shane Henderson on 18/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "NSString+PNGString.h"

@implementation NSString (PNGString)

+ (BOOL)stringIsNilOrEmpty:(NSString *)string
{
    if (!string) {
        return NO;
    }
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (string.length > 0);
}

@end

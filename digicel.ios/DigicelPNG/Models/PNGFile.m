//
//  PNGFile.m
//  DigicelPNG
//
//  Created by Srijith on 30/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGFile.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGFile

@dynamic file;
@dynamic type;

+ (NSString *)parseClassName {
    return @"PNGFile";
}

@end

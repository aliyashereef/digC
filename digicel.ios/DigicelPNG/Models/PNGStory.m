//
//  PNGStory.m
//  DigicelPNG
//
//  Created by Srijith on 30/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGStory.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGStory

@dynamic description;
@dynamic media;
@dynamic user;

+ (NSString *)parseClassName {
    return @"Story";
}

@end

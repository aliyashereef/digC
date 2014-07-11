//
//  PNGCategory.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGCategory.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGCategory
@dynamic name;
@dynamic slug;
@dynamic wpID;
@dynamic parent;

+ (NSString *)parseClassName {
    return @"Categories";
}

@end

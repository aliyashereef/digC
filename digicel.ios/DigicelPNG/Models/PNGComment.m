//
//  PNGComment.m
//  DigicelPNG
//
//  Created by Anand V on 11/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGComment.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGComment

@dynamic content;
@dynamic name;
@dynamic authorName;
@dynamic authorFirstName;
@dynamic authorLastName;
@dynamic commentAuthorId;
@dynamic parent;
@dynamic wpCommentId;

+ (NSString *)parseClassName {
    return @"Comments";
}

@end

//
//  PNGStory.h
//  DigicelPNG
//
//  Created by Srijith on 30/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>
#import "PNGUser.h"

@interface PNGStory : PFObject <PFSubclassing>

@property (retain) NSString *description;
@property (retain) PNGUser *user;
@property (retain) NSArray *media;

+ (NSString *)parseClassName;

@end

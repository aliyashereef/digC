//
//  PNGCategory.h
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>

@interface PNGCategory : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *slug;
@property (retain) NSString *wpID;
@property (retain) NSString *parent;

+ (NSString *)parseClassName;

@end

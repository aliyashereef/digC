//
//  PNGComment.h
//  DigicelPNG
//
//  Created by Anand V on 11/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>

@interface PNGComment : PFObject <PFSubclassing>

@property (retain) NSString *content;
@property (retain) NSString *name;
@property (retain) NSString *authorName;
@property (retain) NSString *authorFirstName;
@property (retain) NSString *authorLastName;
@property (retain) NSNumber *commentAuthorId;
@property NSInteger parent;
@property NSInteger wpCommentId;

+ (NSString *)parseClassName;

@end

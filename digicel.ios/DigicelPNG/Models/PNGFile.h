//
//  PNGFile.h
//  DigicelPNG
//
//  Created by Srijith on 30/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>

@interface PNGFile : PFObject <PFSubclassing>

@property (retain) PFFile *file;
@property (retain) NSString *type;

@end

//
//  PNGImage.m
//  DigicelPNG
//
//  Created by Arundev K S on 11/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGImage.h"

@implementation PNGImage

//  Creates Image object from the given dictionary
+ (PNGImage *)createImageFromDictionary:(NSDictionary *)imageDictionary {
    if(imageDictionary.count == 0) {
        return nil;
    }
    PNGImage *image = [[PNGImage alloc] init];
    [image setImageDetailsFromDictionary:imageDictionary];
    return image;
}

//  Setting image details
- (void)setImageDetailsFromDictionary:(NSDictionary *)imageDictionary {
    if(imageDictionary.count == 0) {
        return;
    }
    if([imageDictionary valueForKey:@"height"]) {
        self.height = [[imageDictionary valueForKey:@"height"] floatValue];
    }
    if([imageDictionary valueForKey:@"width"]) {
        self.width = [[imageDictionary valueForKey:@"width"] floatValue];
    }
    if([imageDictionary valueForKey:@"url"]) {
        self.imageUrl = [[imageDictionary valueForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

@end

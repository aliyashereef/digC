//
//  PNGImage.h
//  DigicelPNG
//
//  Created by Arundev K S on 11/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNGImage : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;

//  Creates Image object from the given dictionary
+ (PNGImage *)createImageFromDictionary:(NSDictionary *)imageDictionary;

//  Setting image details
- (void)setImageDetailsFromDictionary:(NSDictionary *)imageDictionary;

@end

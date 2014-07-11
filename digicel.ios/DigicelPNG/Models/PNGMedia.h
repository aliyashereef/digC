//
//  PNGMedia.h
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNGImage.h"

@interface PNGMedia : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) PNGImage *fullImage;
@property (nonatomic, strong) PNGImage *largeImage;
@property (nonatomic, strong) PNGImage *mediumImage;
@property (nonatomic, strong) PNGImage *thumbnailImage;

+ (PNGMedia *)getFirstMediaFromMediaArray:(NSArray *)medias;

@end

//
//  PNGMedia.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGMedia.h"

@implementation PNGMedia

+ (PNGMedia *)getFirstMediaFromMediaArray:(NSArray *)medias {
    if(medias.count > 0) {
        PNGMedia *media = [[PNGMedia alloc] init];
        NSDictionary *mediaDict = [medias firstObject];
        [media setMediaDetails:mediaDict];
        return media;
    } else {
        return nil;
    }
}

- (void)setMediaDetails:(NSDictionary *)mediaDictionary {
    if(mediaDictionary.count == 0)
        return;
    self.title = [mediaDictionary valueForKey:@"title"];
    self.caption = [mediaDictionary valueForKey:@"caption"];
    self.description = [mediaDictionary valueForKey:@"description"];
    self.mediaId = [mediaDictionary valueForKey:@"id"];
    self.mimeType = [mediaDictionary valueForKey:@"mime_type"];
    self.slug = [mediaDictionary valueForKey:@"slug"];
    NSDictionary *images = [mediaDictionary valueForKey:@"images"];
    if(images.count > 0) {
        if([images valueForKey:@"full"]) {
            self.fullImage = [PNGImage createImageFromDictionary:[images valueForKey:@"full"]];
        }
        if([images valueForKey:@"large"]) {
            self.largeImage = [PNGImage createImageFromDictionary:[images valueForKey:@"large"]];
        }
        if([images valueForKey:@"medium"]) {
            self.mediumImage = [PNGImage createImageFromDictionary:[images valueForKey:@"medium"]];
        }
        if([images valueForKey:@"thumbnail"]) {
            self.thumbnailImage = [PNGImage createImageFromDictionary:[images valueForKey:@"thumbnail"]];
        }
    }
}

@end

//
//  PNGArticle.m
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticle.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGArticle
@dynamic authorID;
@dynamic authorName;
@dynamic content;
@dynamic name;
@dynamic publishedDate;
@dynamic title;
@dynamic wpID;
@dynamic postUrl;
@dynamic wpModifiedDate;
@dynamic customFields;
@dynamic media;
@synthesize medias = _medias;
@synthesize type = _type;
@synthesize thumbNailImageUrl = _thumbNailImageUrl;

+ (NSString *)parseClassName {
    return @"Posts";
}

- (PNGMedia *)getMedias {
    if(!_medias) {
        _medias = [PNGMedia getFirstMediaFromMediaArray:self.media];
    }
    return _medias;
}

- (PNGMedia *)medias {
    if(!_medias) {
        _medias = [PNGMedia getFirstMediaFromMediaArray:self.media];
    }
    return _medias;
}

- (NSString *)postImageURL {
    NSString *imageURL = @"";
    if (self.customFields != nil && [self.customFields valueForKey:@"post_image"]) {
        NSArray *urlList = [self.customFields valueForKey:@"post_image"];
        if ([urlList count] > 0) {
            imageURL = [[urlList objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            imageURL = self.medias.fullImage.imageUrl;
        }
    } else {
        imageURL = self.medias.fullImage.imageUrl;
    }
    return imageURL;
}

- (NSString *)thumbNailImageUrl {
    if(!_thumbNailImageUrl) {
        if(self.postImageURL.length == 0) {
            _thumbNailImageUrl = self.medias.thumbnailImage.imageUrl;
        } else {
            NSMutableString *url = [[NSMutableString alloc] initWithString:self.postImageURL];
            [url replaceOccurrencesOfString:@"." withString:@"-150x150." options:NSBackwardsSearch range:NSMakeRange(url.length-5, 5)];
            _thumbNailImageUrl = url;
        }
    }
    return _thumbNailImageUrl;
}

+ (PNGArticle *)createArticleFromDictionary:(NSDictionary *)articleDictionary {
    
    PNGArticle *article = [[PNGArticle alloc] init];
    [article setArticleDetails:articleDictionary];
    return article;
}

- (void)setArticleDetails:(NSDictionary *)articleDictionary {
    if(!articleDictionary)
        return;
    if([articleDictionary valueForKey:@"id"]) {
        self.wpID = [articleDictionary valueForKey:@"id"];
    }
    if([articleDictionary valueForKey:@"title"]) {
        self.title = [articleDictionary valueForKey:@"title"];
    }
    if([articleDictionary valueForKey:@"modified"]) {
        self.wpModifiedDate = [articleDictionary valueForKey:@"modified"];
    }
    if([articleDictionary valueForKey:@"content"]) {
        self.content = [articleDictionary valueForKey:@"content"];
    }
    if([articleDictionary valueForKey:@"date"]) {
        self.publishedDate = [articleDictionary valueForKey:@"date"];
    }
    if([articleDictionary valueForKey:@"author"]) {
        NSDictionary *authorDictionary = [articleDictionary valueForKey:@"author"];
        if ([authorDictionary valueForKey:@"id"]) {
            self.authorID = [authorDictionary valueForKey:@"id"];
        }
        if ([authorDictionary valueForKey:@"name"]) {
            self.authorName = [authorDictionary valueForKey:@"name"];
        }
    }
}

@end

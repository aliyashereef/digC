//
//  PNGArticle.h
//  DigicelPNG
//
//  Created by Arundev K S on 20/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>
#import "PNGMedia.h"

@interface PNGArticle : PFObject <PFSubclassing>

@property (retain) NSString *authorID;
@property (retain) NSString *authorName;
@property (retain) NSString *content;
@property (retain) NSString *name;
@property (retain) NSString *publishedDate;
@property (retain) NSString *title;
@property (retain) NSString *wpID;
@property (retain) NSString *postUrl;
@property (retain) NSString *wpModifiedDate;
@property (retain) NSDictionary *customFields;
@property (retain) NSArray *media;
@property (nonatomic, strong) NSString *thumbNailImageUrl;
@property (nonatomic, assign) ArticleType type;
@property (nonatomic, strong) PNGMedia *medias;

+ (NSString *)parseClassName;

//  Returns a article object from the given article details dictionary
+ (PNGArticle *)createArticleFromDictionary:(NSDictionary *)articleDictionary;

// Returns Image URL associated with the POST
- (NSString *)postImageURL;

//  getter mthod for thumbNailImageUrl
- (NSString *)thumbNailImageUrl;

@end

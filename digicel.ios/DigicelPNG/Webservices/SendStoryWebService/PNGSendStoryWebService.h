//
//  PNGSendStoryWebService.h
//  DigicelPNG
//
//  Created by Srijith V on 23/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "PNGArticle.h"

typedef void (^sendStorySuccess)(PNGArticle *post);
typedef void (^sendStoryFailure)(NSString *errorMessage);

@interface PNGSendStoryWebService : NSObject

@property (nonatomic, strong) sendStorySuccess successCallback;
@property (nonatomic, strong) sendStoryFailure failureCallback;


- (void)sendStory:(NSString*)content
         withAttachment:(NSArray *)attachments
         withType:(NSString *)type
  requestSucceeded:(void (^)(PNGArticle *post))success
     requestFailed:(void (^)(NSString *errorMessage))failure;

@end

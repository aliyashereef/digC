//
//  PNGAddCommentWebService.h
//  DigicelPNG
//
//  Created by Jayashankar on 19/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef void (^createCommentSuccess)(void);
typedef void (^createCommentFailed)(NSString *errorMsg);

@interface PNGAddCommentWebService : NSObject

@property (nonatomic, strong) createCommentSuccess successCallback;
@property (nonatomic, strong) createCommentFailed failureCallback;

- (void)addComment:(NSString *)comment
         forPostId:(NSString *)postId
  requestSucceeded:(void (^)(void))success
     requestFailed:(void (^)(NSString *errorMsg))failure;

- (void)addReply:(NSString *)reply
    forCommentId:(NSString *)commentId
       forPostId:(NSString *)postId
requestSucceeded:(void (^)(void))success
   requestFailed:(void (^)(NSString *errorMsg))failure;

@end

//
//  PNGAddCommentWebService.m
//  DigicelPNG
//
//  Created by Jayashankar on 19/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGAddCommentWebService.h"

@implementation PNGAddCommentWebService

- (void)executeRequestWithURL:(NSString *)commentURL andData:(NSDictionary *)data {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:commentURL parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (![status isKindOfClass:[NSNull class]] && [status isEqualToString:@"error"]) {
            // Error while adding comment
            self.failureCallback([responseObject valueForKey:@"error"]);
        } else {
            // Post comment successful
            self.successCallback();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (operation.responseString) {
            if ([operation.responseString rangeOfString:@"Duplicate comment"].location != NSNotFound) {
                self.failureCallback(@"Duplicate comment detected; you've already added that");
            } else if ([operation.responseString rangeOfString:@"You are posting comments too quickly"].location != NSNotFound) {
                self.failureCallback(@"You are posting comments too quickly; slow down");
            } else {
                self.failureCallback([error localizedDescription]);
            }
        } else {
            self.failureCallback([error localizedDescription]);
        }
    }];
}

- (void)addComment:(NSString *)comment
         forPostId:(NSString *)postId
  requestSucceeded:(void (^)(void))success
     requestFailed:(void (^)(NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    
    NSString *encodedComment = [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *commentURL = [NSString stringWithFormat:@"%@api/respond/submit_comment_by_user/?post_id=%@&content=%@", kBaseUrl, postId, encodedComment];
    
    NSString *cookie = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthCookie];
    NSDictionary *data = @{@"cookie":cookie};
    
    [self executeRequestWithURL:commentURL andData:data];
}

- (void)addReply:(NSString *)reply
    forCommentId:(NSString *)commentId
       forPostId:(NSString *)postId
requestSucceeded:(void (^)(void))success
   requestFailed:(void (^)(NSString *errorMsg))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    
    NSString *encodedReply = [reply stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *commentURL = [NSString stringWithFormat:@"%@api/respond/submit_comment_by_user/?post_id=%@&comment_parent=%@&content=%@", kBaseUrl, postId, commentId, encodedReply];
    
    NSString *cookie = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthCookie];
    NSDictionary *data = @{@"cookie":cookie};
    
    [self executeRequestWithURL:commentURL andData:data];
}

@end

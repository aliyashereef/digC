//
//  PNGSendStoryWebService.m
//  DigicelPNG
//
//  Created by Srijith V on 23/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSendStoryWebService.h"


@implementation PNGSendStoryWebService

- (void)sendStory:(NSString*)content
   withAttachment:(NSArray *)attachments
         withType:(NSString *)type
 requestSucceeded:(void (^)(PNGArticle *post))success
    requestFailed:(void (^)(NSString *errorMessage))failure {
    
    self.successCallback = success;
    self.failureCallback = failure;
    //get user details
    NSDictionary *userDetails = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    NSString *userNiceName =[userDetails objectForKey:@"nicename"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //get nonce value
    NSString *nonceurl = [NSString stringWithFormat:@"%@api/get_nonce/?controller=posts&method=create_post", kBaseUrl];
    [manager GET:nonceurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject valueForKey:@"nonce"]) {
            
            NSString *nonce = [responseObject valueForKey:@"nonce"];
            NSString *cookieValue = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthCookie];
            //post article
            NSString *postTitle = [NSString stringWithFormat:@"Article_%@", [PNGUtilities getDateStringFromDate:[NSDate date]]];
            NSString *createPostURL = [NSString stringWithFormat:@"%@api/?json=create_post&title=%@&content=%@&author=%@",kBaseUrl, postTitle, content, userNiceName];
            createPostURL = [createPostURL stringByAddingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
            NSString *attachmentsCount = [NSString stringWithFormat:@"%i", attachments.count];
            NSDictionary *dataDictionary = @{@"nonce": nonce, @"cookie": cookieValue, @"attachment_count": attachmentsCount};
            [self createPostWithUrl:createPostURL parameters:dataDictionary attachments:attachments];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.failureCallback(error.localizedDescription);
    }];
}

- (void)createPostWithUrl:(NSString *)createPostUrl parameters:(NSDictionary *)parameters attachments:(NSArray *)attachments {
    //create post call
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:createPostUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (attachments) {
            for (int i = 0; i < attachments.count; i++) {
                NSDictionary *attachment = [attachments objectAtIndex:i];
                
                NSData *mediaData = [attachment objectForKey:DATA_KEY];
                NSString *mediaType = [attachment valueForKey:TYPE_KEY];
                NSString *mediaName = [NSString stringWithFormat:@"attachment_%i", i];
                if ([mediaType isEqualToString:IMAGE_TYPE]) {
                    [formData appendPartWithFileData:mediaData name:mediaName fileName:IMAGE_FILE_NAME_JPG mimeType:IMAGE_MIME_TYPE];
                } else {
                    [formData appendPartWithFileData:mediaData name:mediaName fileName:VIDEO_FILE_NAME mimeType:VIDEO_MIME_TYPE];
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:STATUS] isEqualToString:@"ok"]) {
            PNGArticle *post = [PNGArticle createArticleFromDictionary:[responseObject valueForKey:@"post"]];
            self.successCallback(post);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.failureCallback(error.localizedDescription);
    }];
}
@end

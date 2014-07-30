//
//  PNGFeedsAPITestCase.m
//  DigicelPNG
//
//  Created by qbadmin on 23/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "PNGArticle.h"


@interface PNGFeedsAPITestCase : XCTestCase

@end

@implementation PNGFeedsAPITestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchFeeds
{
    [self initialiseParse];
    __block BOOL isDone     = NO;
    NSNumber *categoryId    = [NSNumber numberWithInt:187];
    NSDictionary *params    = @{@"category":categoryId, @"page":[NSNumber numberWithInt:0]};
    
    [PFCloud callFunctionInBackground:@"getFeed"
                       withParameters:params
                                block:^(NSDictionary *result, NSError *error) {
                                    
                                    XCTAssertNil(error, @"error is nil");
                                    if(!error) {
                                        XCTAssertNotNil(result,@"Result is not nil");
                                        XCTAssert([result isKindOfClass:[NSDictionary class]], @"is kind of NSDictionary class");
                                        NSArray *featured = [result valueForKey:@"featured"];
                                        XCTAssert([featured isKindOfClass:[NSArray class]], @"is kind of NSArray class");
                                        XCTAssertNotNil(featured, @"featured is not nil");
                                        if([featured count] > 0) {
                                            id featuredArticle = featured.firstObject;
                                            XCTAssertNotNil(featuredArticle, @"featured article is not nil");
                                            XCTAssert([featuredArticle isKindOfClass:[PNGArticle class]], @"It is PNGArticle class");
                                        }
                                        NSArray *promoted = [result valueForKey:@"priority"];
                                        XCTAssert([promoted isKindOfClass:[NSArray class]], @"It is NSArray class");
                                        XCTAssertNotNil(promoted, @"promoted is not nil");
                                        if([promoted count] > 1) {
                                            PNGArticle *promotedArticle = promoted.firstObject;
                                            XCTAssertNotNil(promotedArticle, @"promotedArticle is not nil");
                                            XCTAssert([promotedArticle isKindOfClass:[PNGArticle class]],@"PNGArticle class");
                                        }
                                        NSArray *listType = [result valueForKey:@"feed"];
                                        XCTAssertNotNil(listType, @"listType is not nil");
                                        XCTAssert([listType isKindOfClass:[NSArray class]],@"NSArray class");
                                        isDone = YES;
                                    }else
                                    {
                                        XCTFail(@"%@",[error localizedDescription]);
                                        isDone = YES;
                                    }
                                }];
    XCTAssertTrue([self waitFor:&isDone timeout:20],
                  @"Timed out waiting for response asynch method completion");
}

#pragma mark - Function to initialise Parse
- (void)initialiseParse{

    [PNGArticle registerSubclass];
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    
}

#pragma mark - Wait Function to handle asynchronous call
- (BOOL)waitFor:(BOOL *)flag timeout:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    }
    while (!*flag);
    return *flag;
}
@end

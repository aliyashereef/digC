//
//  PNGCommentsAPITestCase.m
//  DigicelPNG
//
//  Created by qbadmin on 23/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "PNGAddCommentWebService.h"


@interface PNGCommentsAPITestCase : XCTestCase

@end

@implementation PNGCommentsAPITestCase

- (void)setUp
{
    [super setUp];
    [self initialiseParse];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Fetch

- (void)testFetchComments
{
    
    __block BOOL isDone         = NO;
    PFQuery *query              = [self queryForComments:@"69739"];
    query.limit                 = 10;
    query.skip                  = 0;
    
    XCTAssertNotNil(query, @"query is not nil");
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [query orderBySortDescriptor:sortDescriptor];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        XCTAssertNotNil(objects, @"objects are not nil");
        XCTAssertNil(error, @"no error");
        XCTAssert([objects isKindOfClass:[NSArray class]], @"is kind of NSArray class");
        isDone = YES;
        if (error) {
            XCTFail(@"%@",[error localizedDescription]);
            isDone = YES;
        }
    }];
    
    XCTAssertTrue([self waitFor:&isDone timeout:5],
                  @"Timed out waiting for response asynch method completion");
}

- (void)testFetchCommentsCount {
    
    __block BOOL isDone     = NO;
    PFQuery *query          = [self queryForComments:@"69739"];
    
    XCTAssertNotNil(query, @"query is not nil");
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        
        XCTAssertNil(error, @"No error");
        isDone = YES;
        if (error) {
            XCTFail(@"%@",[error localizedDescription]);
            isDone = YES;
        }
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:5],
                  @"Timed out waiting for response asynch method completion");
    
}

- (void)testFetchRepliesForCommentWithId{
    
    __block BOOL isDone     = NO;
    PFQuery *query          = [self queryForReplyWithId:2370];
    query.limit             = 10;
    query.skip              = 0;
    
    XCTAssertNotNil(query, @"query is not nil");
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [query orderBySortDescriptor:sortDescriptor];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        XCTAssertNotNil(objects, @"objects are not nil");
        XCTAssertNil(error, @"no error");
        XCTAssert([objects isKindOfClass:[NSArray class]], @"is kind of NSArray class");
        isDone = YES;
        if (error) {
            XCTFail(@"%@",[error localizedDescription]);
            isDone = YES;
        }
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:5],
                  @"Timed out waiting for response asynch method completion");
}

- (void)testFetchReplyCountWithId{
    
    __block BOOL isDone         = NO;
    PFQuery *query              = [self queryForReplyWithId:2370];
    
    XCTAssertNotNil(query, @"query is not nil");
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        XCTAssertNil(error, @"No error");
        isDone = YES;
        if (error) {
            XCTFail(@"%@",[error localizedDescription]);
            isDone = YES;
        }
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:5],
                  @"Timed out waiting for response asynch method completion");
}

#pragma mark - Post

- (void)testAddValidComment {
    
     __block BOOL isDone    = NO;
    
    NSString *comment               = [self getUniqueString];
    NSString *postId                = @"93088";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"arundev.s@marker.co.nz|1407404566|d8a3cdbba842099e391fbd3f5cd0a2be" forKey:kAuthCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];

    PNGAddCommentWebService *addCommentWebservice = [[PNGAddCommentWebService alloc] init];
    [addCommentWebservice addComment:comment forPostId:postId requestSucceeded:^{
        
        isDone = YES;
        
    } requestFailed:^(NSString *errorMsg) {
        
        XCTFail(@"%@",errorMsg);
        isDone = YES;
    }];
    
    XCTAssertTrue([self waitFor:&isDone timeout:10],
                  @"Timed out waiting for response asynch method completion");
}

- (void)testAddInvalidComment {
    
    __block BOOL isDone    = NO;
    
    NSString *comment       = @"test comment";
    NSString *postId        = @"93088";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"arundev.s@marker.co.nz|1407404566|d8a3cdbba842099e391fbd3f5cd0a2be" forKey:kAuthCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PNGAddCommentWebService *addCommentWebservice = [[PNGAddCommentWebService alloc] init];
    [addCommentWebservice addComment:comment forPostId:postId requestSucceeded:^{
        
        XCTFail(@"Invalid Command");
        isDone = YES;
        
    } requestFailed:^(NSString *errorMsg) {
        
        XCTAssertNotNil(errorMsg, @"error message is not nil");
        isDone = YES;
    }];
    
    XCTAssertTrue([self waitFor:&isDone timeout:10],
                  @"Timed out waiting for response asynch method completion");
}


- (void)testAddValidReply{
    
    __block BOOL isDone             = NO;
    NSString *reply                 = [self getUniqueString];
    NSString *commentId             = @"2370";
    NSString *postId                = @"81934";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"arundev.s@marker.co.nz|1407404566|d8a3cdbba842099e391fbd3f5cd0a2be" forKey:kAuthCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PNGAddCommentWebService *addCommentWebservice = [[PNGAddCommentWebService alloc] init];
    [addCommentWebservice addReply:reply forCommentId:commentId forPostId:postId requestSucceeded:^{
        
       isDone = YES;
    }
    requestFailed:^(NSString *errorMsg){
        
        isDone = YES;
        XCTFail(@"%@",errorMsg);
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:30],
                  @"Timed out waiting for response asynch method completion");
}

- (void)testAddInvalidReply{
    
    __block BOOL isDone     = NO;
    NSString *reply         = @"asdadasdaasd";
    NSString *commentId     = @"2370";
    NSString *postId        = @"81934";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"arundev.s@marker.co.nz|1407404566|d8a3cdbba842099e391fbd3f5cd0a2be" forKey:kAuthCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PNGAddCommentWebService *addCommentWebservice = [[PNGAddCommentWebService alloc] init];
    [addCommentWebservice addReply:reply forCommentId:commentId forPostId:postId requestSucceeded:^{
        
        XCTFail(@"Invalid Reply");
        isDone = YES;
    }
    requestFailed:^(NSString *errorMsg){
                         
                         isDone = YES;
                     }];
    XCTAssertTrue([self waitFor:&isDone timeout:30],
                  @"Timed out waiting for response asynch method completion");
}

#pragma mark - To get Query

- (PFQuery*)queryForComments:(NSString *)postId {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"postId" equalTo:postId];
    [query whereKey:@"parent" equalTo:[NSNumber numberWithInt:0]];      // Fetching only the top-level comments initially
    return query;
}

- (PFQuery*)queryForReplyWithId:(NSInteger)commentId {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"parent" equalTo:[NSNumber numberWithInteger:commentId]];
    return query;
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

#pragma mark - Function to get unique string

-(NSString *)getUniqueString
{
    NSDate *currentDateInLocal      = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'"];
    NSString *uniqueString          = [dateFormatter stringFromDate:currentDateInLocal];
    return uniqueString;
}

#pragma mark - Function to initialise Parse

- (void)initialiseParse
{
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
}


@end

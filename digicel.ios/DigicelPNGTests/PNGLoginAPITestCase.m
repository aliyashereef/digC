//
//  PNGLoginAPITestCase.m
//  DigicelPNG
//
//  Created by qbadmin on 22/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PNGLoginWebservice.h"

@interface PNGLoginAPITestCase : XCTestCase

@end

@implementation PNGLoginAPITestCase

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

#pragma mark - Valid Id

- (void)testLoginWebserviceWithValidId
{
    __block BOOL isDone             = NO;
    PNGLoginWebservice *logIn       = [[PNGLoginWebservice alloc] init];
    NSString *email                 = @"arundev.s@marker.co.nz";
    NSString *password              = @"11111";
    
    [logIn userLogin:email password:password requestSucceeded:^(PNGUser *user){
        
        XCTAssertNotNil(user, @"user is not nil");
        XCTAssert([user isKindOfClass:[PNGUser class]], @"user is of PNGUser class");
        isDone = YES;
    }requestFailed:^(NSString *errorMsg){
        
        XCTFail(@"%@",errorMsg);
        isDone = YES;
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:30],
                  @"Timed out waiting for response asynch method completion");
}

#pragma mark - Invalid Id

- (void)testLoginWebserviceWithInvalidId
{
    __block BOOL isDone             = NO;
    PNGLoginWebservice *logIn       = [[PNGLoginWebservice alloc] init];
    NSString *email                 = @"arunadadasddev.s@marker.co.nz";
    NSString *password              = @"11111";
    
    [logIn userLogin:email password:password requestSucceeded:^(PNGUser *user){
        
        XCTAssertNotNil(user, @"user is not nil");
        XCTAssert([user isKindOfClass:[PNGUser class]], @"user is of PNGUser class");
        isDone = YES;
    }requestFailed:^(NSString *errorMsg){
        
        XCTFail(@"%@",errorMsg);
        isDone = YES;
    }];
    XCTAssertTrue([self waitFor:&isDone timeout:30],
                  @"Timed out waiting for response asynch method completion");
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

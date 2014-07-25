//
//  PNGSignupAPITestCase.m
//  DigicelPNG
//
//  Created by qbadmin on 22/07/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PNGRegistrationWebservice.h"

@interface PNGSignupAPITestCase : XCTestCase

@end

@implementation PNGSignupAPITestCase

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

- (void)testRegistrationWebservice
{
    __block BOOL isDone = NO;
    PNGRegistrationWebservice *registration     = [[PNGRegistrationWebservice alloc] init];
    PNGUser *user                               = [[PNGUser alloc] init];
    NSString *password                          = @"adasdaD";
    user.email                                  = @"asdasd@asda.com";
    user.firstName                              = @"asdasdad";
    user.lastName                               = @"adasd";
    user.displayname                            = @"asdasdad";
    user.avatar                                 = @"asdad";
    user.niceName                               = @"asdadaS";
    user.userId                                 = @"dasd";
    user.username                               = @"asdad";
    
    [registration userRegistration:user password:password requestSucceeded:^(PNGUser *user){
        
        XCTAssertNotNil(user, @"user is not nil");
        XCTAssert([user isKindOfClass:[PNGUser class]], @"user is of PNGUser class");
        isDone = YES;
    }
    requestFailed:^(PNGUser *user, NSString *errorMsg){
        
        XCTAssertNotNil(user, @"user is not nil");
        XCTAssert([user isKindOfClass:[PNGUser class]], @"user is of PNGUser class");
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

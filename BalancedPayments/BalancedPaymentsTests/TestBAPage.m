//
//  TestBAPage.m
//  BalancedPayments
//
//  Created by Victor Lin on 2014/12/31.
//  Copyright (c) 2014年 Balanced Payments. All rights reserved.
//

#import "BAPage.h"
#import "BAMarketplace.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AGAsyncTestHelper.h"

@interface TestBAPage : XCTestCase

@end

@implementation TestBAPage

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPage {
    BAAPI *api = [[BAAPI alloc] initWithBaseURL:@"https://api.balancedpayments.com"];
    // TODO: generate a new marketplace for testing
    api.apiKey = @"ak-test-1WN6czAWMOebylcjAJnBXbO7GX0awPWCG";
    
    __block BOOL done = NO;
    BAPage *page = [[BAPage alloc] initWithInitialPath:@"/marketplaces" api:api];
    [page loadNextPage].then(^() {
        done = YES;
    });
    
    AGWW_WAIT_WHILE(!done, 10.0);
    XCTAssertEqual(page.objects.count, 1);
    
    BAMarketplace *marketplace = page.objects[0];
    XCTAssertTrue([marketplace isKindOfClass:[BAMarketplace class]]);
    
    BAPage *debits = marketplace.resources[@"debits"];
    XCTAssertTrue([debits isKindOfClass:[BAPage class]]);
    NSString *expectedDebitsPath = [NSString stringWithFormat:@"%@/debits", marketplace.href];
    XCTAssertEqualObjects(debits.initialPath, expectedDebitsPath);
    
    BAPage *credits = marketplace.resources[@"credits"];
    XCTAssertTrue([credits isKindOfClass:[BAPage class]]);
    NSString *expectedCreditsPath = [NSString stringWithFormat:@"%@/credits", marketplace.href];
    XCTAssertEqualObjects(credits.initialPath, expectedCreditsPath);
    // TODO: ensure marketplace is loaded correctly
}



@end
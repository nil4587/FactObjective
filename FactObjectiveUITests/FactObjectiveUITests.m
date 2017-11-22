//
//  FactObjectiveUITests.m
//  FactObjectiveUITests
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FactObjectiveUITests : XCTestCase

@end

@implementation FactObjectiveUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    if (@available(iOS 9.0, *)) {
        [[[XCUIApplication alloc] init] launch];
    } else {
        // Fallback on earlier versions
    }
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    if (@available(iOS 9.0, *)) {
        XCUIApplication *app = [[XCUIApplication alloc] init];
        [app.navigationBars[@"FactsListView"].buttons[@"Refresh"] tap];
        /*@START_MENU_TOKEN@*/[app.tables.cells.staticTexts[@"Click on Refresh icon or \"Pull to Refresh\" to fetch the data from server."] swipeDown];/*[["app.tables",".cells.staticTexts[@\"Click on Refresh icon or \\\"Pull to Refresh\\\" to fetch the data from server.\"]","["," swipeDown];"," swipeRight];",".staticTexts[@\"Click on Refresh icon or \\\"Pull to Refresh\\\" to fetch the data from server.\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,1,1]]@END_MENU_TOKEN@*/
    } else {
        // Fallback on earlier versions
    }
}

@end

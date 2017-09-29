//
//  slidingmessageTests.swift
//  slidingmessageTests
//
//  Created by Jonathan Stone on 7/18/15.
//  Copyright (c) 2015 CompassionApps. All rights reserved.
//

import UIKit
import XCTest
import slidingmessage

class slidingmessageTests: XCTestCase {

    var theMessageControl: SlidingMessage?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        theMessageControl = createSlidingMessage()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func createSlidingMessage()->SlidingMessage {
        let slidingMessage = SlidingMessage(
            parentView: UIView(),
            autoHideDelaySeconds: 2,
            backgroundColor: UIColor.red,
            foregroundColor: UIColor.white,
            minimumHeight: 200,
            positionBelowControl: nil,
            font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        )

        return slidingMessage
    }

    func testCreateSlidingMessage() {
        XCTAssert(theMessageControl != nil, "slidingMessage exists")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

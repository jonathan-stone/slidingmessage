//
//  LabelWithAutowrapTests.swift
//  slidingmessage
//
//  Created by Jonathan Stone on 9/15/17.
//  Copyright © 2017 CompassionApps. All rights reserved.
//

import XCTest
@testable import slidingmessage

class LabelWithAutowrapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let newLabel = LabelWithAutoWrap()
        let testText = "Test label text"
        newLabel.text = testText
        XCTAssertTrue(newLabel.text == testText)
    }
    
}

//
//  ApaNYTimesTests.swift
//  ApaNYTimesTests
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import XCTest
@testable import ApaNYTimes

class ApaNYTimesTests: XCTestCase {
    var sut: NewsManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

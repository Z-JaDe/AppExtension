//
//  TimerTests.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import XCTest
@testable import ProjectBasic
class TimerTests: XCTestCase {
    func testTimer() {
        var value = 0
        let expectation = self.expectation(description: "timer")
        Timer.scheduleTimer(0.001, repeats: true) { (timer) in
            value += 1
            print(value)
            if value > 10 {
                timer?.invalidate()
                expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: 200) { (_) in

        }
    }
}

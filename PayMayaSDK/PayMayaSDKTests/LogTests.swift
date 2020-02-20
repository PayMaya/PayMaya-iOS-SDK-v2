//
//  Copyright (c) 2020 PayMaya Philippines, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import PayMayaSDK

class LogTests: XCTestCase {
    
    let logger = MockLogger()
    
    override func setUp() {
        Log.logger = logger
    }
    
    func test_whenLogLevelIsOff_doesntLogAnything() {
        Log.logLevel = .off
        Log.error("error")
        Log.info("info")
        Log.verbose("verbose")
        XCTAssertTrue(logger.lastCapturedLog == "")
        XCTAssertEqual(logger.numberOfCalls, 0)
    }
    
    func test_whenLogLevelIsError_logsOnlyError() {
        Log.logLevel = .error
        Log.info("info")
        Log.verbose("verbose")
        XCTAssertTrue(logger.lastCapturedLog == "")
        XCTAssertEqual(logger.numberOfCalls, 0)
        Log.error("error")
        Log.info("info")
        XCTAssertTrue(logger.lastCapturedLog.contains("error"))
        XCTAssertEqual(logger.numberOfCalls, 1)
    }
    
    func test_whenLogLevelIsDebug_logsInfoAndError() {
        Log.logLevel = .debug
        Log.info("info")
        Log.verbose("verbose")
        XCTAssertTrue(logger.lastCapturedLog.contains("info"))
        XCTAssertEqual(logger.numberOfCalls, 1)
        Log.error("error")
        Log.info("info")
        Log.verbose("verbose")
        XCTAssertTrue(logger.lastCapturedLog.contains("info"))
        XCTAssertEqual(logger.numberOfCalls, 3)
    }
    
    func test_whenLogLevelIsAll_logsEveything() {
        Log.logLevel = .all
        Log.info("info")
        Log.verbose("verbose")
        Log.error("error")
        XCTAssertEqual(logger.numberOfCalls, 3)
    }
    
}

class MockLogger: Logger {
    var lastCapturedLog = ""
    var numberOfCalls = 0
    
    func log(_ text: String) {
        numberOfCalls += 1
        lastCapturedLog = text
    }
}

//
//  UptimeLoggerTests.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 17/04/23.
//

import XCTest
@testable import UptimeLogger

final class LogItemInfoTests: XCTestCase {
    
    func testLogItemInfoInitialization() throws {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let content = """
version: 4
init: 2023-04-17_00-13-40
ended: 2023-04-17_00-13-43
sysversion: 13.4
batery: 72%
charging: false
boottime: 1681697439
uptime: 3784
logprocessinterval: 2
logprocess: true
"""
        let logItemInfo = LogItemInfo(fileName: fileName, content: content)
        
        XCTAssertEqual(logItemInfo.fileName, fileName)
        XCTAssertEqual(logItemInfo.version, 4)
        XCTAssertEqual(logItemInfo.systemVersion, "13.4")
        XCTAssertEqual(logItemInfo.batery, 72)
        XCTAssertEqual(logItemInfo.charging, false)
        XCTAssertEqual(logItemInfo.systemBootTime, Date(timeIntervalSince1970: 1681697439))
        XCTAssertEqual(logItemInfo.systemUptime, 3784)
        XCTAssertEqual(logItemInfo.logProcessInterval, 2)
        XCTAssertEqual(logItemInfo.hasProcess, true)
        XCTAssertEqual(logItemInfo.shutdownAllowed, false)
        XCTAssertEqual(logItemInfo.edited, false)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let expectedInit = formatter.date(from: "2023-04-17_00-13-40")
        let expectedEndTime = formatter.date(from: "2023-04-17_00-13-43")

        XCTAssertEqual(logItemInfo.scriptStartTime, expectedInit)
        XCTAssertEqual(logItemInfo.scriptEndTime, expectedEndTime)
    }
    
    func testFromOldVersion() throws {
        let content = """
version: 1
last record: 0 days, 02:53:58
"""
        let logItemInfo = LogItemInfo(fileName: "", content: content)

        XCTAssertEqual(logItemInfo.version, 1)
        XCTAssertEqual(logItemInfo.systemUptime, (2 * 60 * 60) + (53 * 60) + 58)
    }

    func testLogItemInfoShutDownAllowedManually() throws {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let content = """
manually: shutdown allowed
"""
        let logItemInfo = LogItemInfo(fileName: fileName, content: content)
        
        XCTAssertEqual(logItemInfo.fileName, fileName)
        XCTAssertEqual(logItemInfo.version, 1)
        XCTAssertEqual(logItemInfo.systemVersion, nil)
        XCTAssertEqual(logItemInfo.batery, nil)
        XCTAssertEqual(logItemInfo.charging, nil)
        XCTAssertEqual(logItemInfo.systemBootTime, nil)
        XCTAssertEqual(logItemInfo.systemUptime, nil)
        XCTAssertEqual(logItemInfo.logProcessInterval, nil)
        XCTAssertEqual(logItemInfo.hasProcess, false)
        XCTAssertEqual(logItemInfo.shutdownAllowed, true)
        XCTAssertEqual(logItemInfo.edited, true)
    }
    
    func testLogItemInfoShutDownAllowedUndo() throws {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let content = """
manually: shutdown unexpected
"""
        let logItemInfo = LogItemInfo(fileName: fileName, content: content)
        
        XCTAssertEqual(logItemInfo.fileName, fileName)
        XCTAssertEqual(logItemInfo.version, 1)
        XCTAssertEqual(logItemInfo.systemVersion, nil)
        XCTAssertEqual(logItemInfo.batery, nil)
        XCTAssertEqual(logItemInfo.charging, nil)
        XCTAssertEqual(logItemInfo.systemBootTime, nil)
        XCTAssertEqual(logItemInfo.systemUptime, nil)
        XCTAssertEqual(logItemInfo.logProcessInterval, nil)
        XCTAssertEqual(logItemInfo.hasProcess, false)
        XCTAssertEqual(logItemInfo.shutdownAllowed, false)
        XCTAssertEqual(logItemInfo.edited, false)
    }
    
    func testLogItemInfoShutDownDenyedManually() throws {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let content = """
shutdown allowed
manually: shutdown unexpected
"""
        let logItemInfo = LogItemInfo(fileName: fileName, content: content)
        
        XCTAssertEqual(logItemInfo.fileName, fileName)
        XCTAssertEqual(logItemInfo.version, 1)
        XCTAssertEqual(logItemInfo.systemVersion, nil)
        XCTAssertEqual(logItemInfo.batery, nil)
        XCTAssertEqual(logItemInfo.charging, nil)
        XCTAssertEqual(logItemInfo.systemBootTime, nil)
        XCTAssertEqual(logItemInfo.systemUptime, nil)
        XCTAssertEqual(logItemInfo.logProcessInterval, nil)
        XCTAssertEqual(logItemInfo.hasProcess, false)
        XCTAssertEqual(logItemInfo.shutdownAllowed, false)
        XCTAssertEqual(logItemInfo.edited, true)
    }
}

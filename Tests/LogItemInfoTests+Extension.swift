//
//  LogItemInfoTest+Extension.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 25/04/23.
//

import XCTest

@testable import UptimeLogger

final class LogItemInfoTestsExtension: XCTestCase {
    
    var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }

    var fileNameFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = LogItemInfo.fileNameFormatter
        return formatter
    }

    func testFormatedNull() throws {
        XCTAssertEqual(LogsProviderMock.empty.formattedUptime, "00s")
    }

    func testFormatedFull() throws {
        let content = "uptime: 86400"
        let logItemInfo = LogItemInfo("", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "1d 00h 00m 00s")
        XCTAssertEqual(logItemInfo.formattedUptime, "1d 00h 00m 00s")
    }

    func testFormatedHours() throws {
        let content = "uptime: 3784"
        let logItemInfo = LogItemInfo("", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "01h 03m 04s")
    }

    func testFormatedMinutes() throws {
        let content = "uptime: 125"
        let logItemInfo = LogItemInfo("", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "02m 05s")
    }

    func testFormatedSeconds() throws {
        let content = "uptime: 3"
        let logItemInfo = LogItemInfo("", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "03s")
    }
    
    func testStartUpFormat() {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let logItemInfo = LogItemInfo(fileName, content: "")

        XCTAssertEqual(logItemInfo.formattedStartUptime, "17/04/2023 ás 00:13:40")
    }

    func testYesterday() {
        var logItemInfo = LogItemInfo(fileNameFormatter.string(from: Date().addingTimeInterval(-1 * 24 * 60 * 60)))
        let hour = hourFormatter.string(from: logItemInfo.scriptStartTime)

        XCTAssertEqual(logItemInfo.formattedStartUptime, "ontem ás \(hour)")
    }

    func testToday() {
        var logItemInfo = LogItemInfo(fileNameFormatter.string(from: Date()))
        let hour = hourFormatter.string(from: logItemInfo.scriptStartTime)

        XCTAssertEqual(logItemInfo.formattedStartUptime, "hoje ás \(hour)")
    }

    func testEndtimeFormat() {
        let logItemInfo = LogItemInfo("", content: "ended: 2022-07-24_12-15-05")
        XCTAssertEqual(logItemInfo.formattedEndtime, " 24/07/2022 ás 12:15:05")
    }

    func testEndtimeFormatNull() {
        XCTAssertEqual(LogsProviderMock.empty.formattedEndtime, "")
    }

    func testBootimeFormat() {
        let logItemInfo = LogItemInfo("", content: "boottime:")
        XCTAssertEqual(logItemInfo.formattedBoottime, nil)
    }

    func testBootimeFormatNull() {
        XCTAssertEqual(LogsProviderMock.empty.formattedBoottime, nil)
    }

}

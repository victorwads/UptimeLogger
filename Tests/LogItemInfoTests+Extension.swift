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

    func testFormatedNull() throws {
        XCTAssertEqual(LogItemInfo.empty.formattedUptime, "0 segundos")
    }

    func testFormatedFull() throws {
        let content = "uptime: 86400"
        let logItemInfo = LogItemInfo(fileName: "", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "1 dias, 0 horas, 0 minutos, 0 segundos")
    }

    func testFormatedHours() throws {
        let content = "uptime: 3784"
        let logItemInfo = LogItemInfo(fileName: "", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "1 horas, 3 minutos, 4 segundos")
    }

    func testFormatedMinutes() throws {
        let content = "uptime: 125"
        let logItemInfo = LogItemInfo(fileName: "", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "2 minutos, 5 segundos")
    }

    func testFormatedSeconds() throws {
        let content = "uptime: 3"
        let logItemInfo = LogItemInfo(fileName: "", content: content)
        
        XCTAssertEqual(logItemInfo.formattedUptime, "3 segundos")
    }
    
    func testStartUpFormat() {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let logItemInfo = LogItemInfo(fileName: fileName, content: "")

        XCTAssertEqual(logItemInfo.formattedStartUptime, "17/04/2023 ás 00:13:40")
    }

    func testYesterday() {
        var logItemInfo = LogItemInfo.empty
        logItemInfo.scriptStartTime = Date().addingTimeInterval(-1 * 24 * 60 * 60)
        
        let hour = hourFormatter.string(from: logItemInfo.scriptStartTime)

        XCTAssertEqual(logItemInfo.formattedStartUptime, "ontem ás \(hour)")
    }

    func testToday() {
        var logItemInfo = LogItemInfo.empty
        logItemInfo.scriptStartTime = Date()
        
        let hour = hourFormatter.string(from: logItemInfo.scriptStartTime)
        XCTAssertEqual(logItemInfo.formattedStartUptime, "hoje ás \(hour)")
    }

    func testEndtimeFormat() {
        let logItemInfo = LogItemInfo(fileName: "", content: "ended: 2022-07-24_12-15-05")
        XCTAssertEqual(logItemInfo.formattedEndtime, " 24/07/2022 ás 12:15:05")
    }

    func testEndtimeFormatNull() {
        XCTAssertEqual(LogItemInfo.empty.formattedEndtime, "")
    }

    func testBootimeFormat() {
        let logItemInfo = LogItemInfo(fileName: "", content: "boottime:")
        XCTAssertEqual(logItemInfo.formattedBoottime, nil)
    }

    func testBootimeFormatNull() {
        XCTAssertEqual(LogItemInfo.empty.formattedBoottime, nil)
    }

}

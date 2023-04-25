//
//  VersionTests.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 20/04/23.
//

import Foundation
import XCTest

@testable import UptimeLogger

final class VersionCompareTests: XCTestCase {
    
    
    func testVersionLower() {
        let version1 = "1.2.3"
        let version2 = "1.3.0"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, -1)
    }
    
    func testVersionLower2() {
        let version1 = "1.2"
        let version2 = "1.3.0"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, -1)
    }
    
    func testVersionBigger() {
        let version1 = "2.2.3"
        let version2 = "1.3"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, 1)
    }

    func testVersionEqual() {
        let version1 = "2.0.0"
        let version2 = "2.0"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, 0)
    }
}

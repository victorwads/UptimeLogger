//
//  VersionTests.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 20/04/23.
//

import Foundation
import XCTest

@testable import UptimeLogger

final class VersionTests: XCTestCase {
    
    
    func testVersionCompare() {
        let version1 = "1.2.3"
        let version2 = "1.3.0"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, -1)
        
        switch comparisonResult {
        case 1:
            print("\(version1) é maior que \(version2)")
        case -1:
            print("\(version1) é menor que \(version2)")
        default:
            print("\(version1) é igual a \(version2)")
        }
    }
    
    func testVersionCompare2() {
        let version1 = "1.2"
        let version2 = "1.3.0"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, -1)
        
        switch comparisonResult {
        case 1:
            print("\(version1) é maior que \(version2)")
        case -1:
            print("\(version1) é menor que \(version2)")
        default:
            print("\(version1) é igual a \(version2)")
        }
    }
    
    func testVersionCompare3() {
        let version1 = "1.2.3"
        let version2 = "1.3"
        
        let comparisonResult = version1.compareVersion(version2)
        XCTAssertEqual(comparisonResult, -1)
        
        switch comparisonResult {
        case 1:
            print("\(version1) é maior que \(version2)")
        case -1:
            print("\(version1) é menor que \(version2)")
        default:
            print("\(version1) é igual a \(version2)")
        }
    }
}

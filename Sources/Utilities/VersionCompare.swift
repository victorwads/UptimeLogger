//
//  VersionCompare.swift
//  UptimeLogger
//
//  Created by Victor Wads on 20/04/23.
//

import Foundation

extension String {
    func compareVersion(_ version2: String) -> Int {
        let version1 = self
        let versionComponents1 = version1.split(separator: ".").map { Int($0) ?? 0 }
        let versionComponents2 = version2.split(separator: ".").map { Int($0) ?? 0 }
        
        let maxLength = max(versionComponents1.count, versionComponents2.count)
        
        for i in 0..<maxLength {
            let v1 = i < versionComponents1.count ? versionComponents1[i] : 0
            let v2 = i < versionComponents2.count ? versionComponents2[i] : 0
            
            if v1 > v2 {
                return 1
            } else if v1 < v2 {
                return -1
            }
        }
        
        return 0
    }
}

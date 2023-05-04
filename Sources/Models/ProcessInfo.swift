//
//  ProcessInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 18/04/23.
//

import Foundation

struct ProcessLogInfo {
    
    static let example = ProcessLogInfo("root                 1   1,1  0,1 11:42     2:35.88 /sbin/launchd")!
    
    let user: String
    let pid: Int
    let cpu: Double
    let mem: Double
    let started: String
    let time: String
    let command: String

    init?(_ line: String) {
        let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if (components.count < 7) {
            return nil
        }
        user = components[0]
        pid = Int(components[1]) ?? 0
        cpu = Double(components[2].replacingOccurrences(of: ",", with: ".")) ?? 0.0
        mem = Double(components[3].replacingOccurrences(of: ",", with: ".")) ?? 0.0
        started = components[4]
        time = components[5]
        command = components[6...].joined(separator: " ")
    }
    
    static func processFile(content: String) -> [ProcessLogInfo] {
        let lines = content.components(separatedBy: "\n").dropFirst()
        return lines.map { line in ProcessLogInfo(line) }.filterNonNil()
    }
}

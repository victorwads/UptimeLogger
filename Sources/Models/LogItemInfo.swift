//
//  LogItemInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

struct LogItemInfo: Identifiable {
    static let fileNameFormatter = "'log_'yyyy-MM-dd_HH-mm-ss'.txt'"
    static let shutdownAllowed = "shutdown allowed"
    static let shutdownUnexpected = "shutdown unexpected"
    static let editedLog = "manually: "

    let id: UUID
    let fileName: String
    let version: Int
    let scriptStartTime: Date
    var scriptEndTime: Date? = nil

    var edited: Bool = false
    var shutdownAllowed: Bool = false

    var systemVersion: String? = nil
    var systemBootTime: Date? = nil
    var systemUptime: TimeInterval? = nil
    var systemActivetime: TimeInterval? = nil

    var batery: Int? = nil
    var charging: Bool? = nil

    let logProcessInterval: Int
    let hasProcess: Bool

    init(_ name: String = "", content: String = "") {
        fileName = name
        id = UUID()
        let lines = content.components(separatedBy: "\n")
        let formatter = DateFormatter()
        var autoShuwDownAllowed = false
        var edition: String? = nil

        //# init from file name
        formatter.dateFormat = LogItemInfo.fileNameFormatter
        scriptStartTime = formatter.date(from: fileName) ?? Date.distantPast
        
        var _version = 1
        var _logProcessInterval = 0

        //# LOG V4
        for line in lines {
            switch true {
            //# version: [0-9]+
            case line.hasPrefix("version: "):
                _version = LogItemInfo.extractNumber(line, 1)
            //# ended: %Y-%m-%d_%H-%M-%S
            case line.hasPrefix("ended: "):
                scriptEndTime = LogItemInfo.extractScriptEndTime(from: line, formatter: formatter)
            //# sysversion: String
            case line.hasPrefix("sysversion: "):
                systemVersion = line.components(separatedBy: ": ").last
            //# batery: [0-9]+%
            case line.hasPrefix("batery: "):
                batery = LogItemInfo.extractNumber(line)
            //# charging: true/false
            case line.hasPrefix("charging: "):
                charging = line.contains("true") ? true : line.contains("false") ? false : nil
            //# boottime: [0-9]+ (timestamp)
            case line.hasPrefix("boottime: "):
                systemBootTime = LogItemInfo.extractNumber(line).let { Date.init(timeIntervalSince1970: Double($0)) }
            //# uptime: [0-9]+ (seconds interval)
            case line.hasPrefix("uptime: "):
                systemUptime = LogItemInfo.extractNumber(line).let { TimeInterval($0) }
            //# activetime: [0-9]+
            case line.hasPrefix("activetime: "):
                systemActivetime = LogItemInfo.extractNumber(line).let { TimeInterval($0) }
            //# logprocessinterval: [0-9]+
            case line.hasPrefix("logprocessinterval: "):
                _logProcessInterval = LogItemInfo.extractNumber(line, 0)
            case line == LogItemInfo.shutdownAllowed:
                autoShuwDownAllowed = true
            case line.hasPrefix(LogItemInfo.editedLog):
                edition = line.replacingOccurrences(of: LogItemInfo.editedLog, with: "")
            default: break;
            }
        }

        //version = _version
        version = _version
        logProcessInterval = _logProcessInterval
        hasProcess = _logProcessInterval > 0

        // Extract shutdown allowed
        if lines.first(where: { $0.hasPrefix(LogItemInfo.editedLog + LogItemInfo.shutdownUnexpected) }) != nil {
            shutdownAllowed = false
        } else {
            shutdownAllowed = lines.first(where: {$0.hasSuffix(LogItemInfo.shutdownAllowed)}) != nil
        }
        
        // Extract Edited
        edited = edition != nil && edition != (autoShuwDownAllowed ? LogItemInfo.shutdownAllowed : LogItemInfo.shutdownUnexpected)

        // Extract uptime older versions
        if let uptimeString = lines.first(where: {
            $0.hasPrefix("last record:") || // V0
            $0.hasPrefix("lastrecord:")     // V1
        })?.components(separatedBy: ": ").last {
            systemUptime = LogItemInfo.fromOldVersion(uptimeString)
        }
    }
    
    static private func extractNumber(_ line: String, _ defaultNumber: Int) -> Int {
        return extractNumber(line) ?? defaultNumber
    }

    static private func extractNumber(_ line: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
        let numbers = regex.stringByReplacingMatches(in: line, range: NSRange(location: 0, length: line.count), withTemplate: "")
        return Int(numbers)
    }
    
    static private func extractScriptEndTime(from line: String, formatter: DateFormatter) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        guard let endTimeString = line.components(separatedBy: ": ").last else { return nil }
        return formatter.date(from: endTimeString)
    }

    static private func fromOldVersion(_ uptimeString: String) -> TimeInterval? {
        let parts = uptimeString.components(separatedBy: ", ")
        let dayPart = parts.first(where: {$0.contains("days")})?.replacingOccurrences(of: " days", with: "") ?? "0"
        guard let timeParts = parts.last?.components(separatedBy: ":").compactMap({ Int($0) }) else { return 0 }
        
        if timeParts.count < 3 {
            return nil
        }
        
        let day = Int(dayPart) ?? 0
        let days: Int = day * 86400
        let hours: Int = timeParts[0] * 3600
        let minutes: Int = timeParts[1] * 60
        let seconds: Int = timeParts[2]
        return  TimeInterval( days + hours + minutes + seconds )
    }

}

extension LogItemInfo {

    var formattedUptime: String {
        let totalSeconds = Int(self.systemUptime ?? 0)
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        var result = ""
        if days > 0 {
            result += "\(days)\(String.localized(.dateDays)) "
        }
        if hours > 0 || days > 0 {
            result += "\(padNumber(hours))\(String.localized(.dateHours)) "
        }
        if minutes > 0 || hours > 0 || days > 0 {
            result += "\(padNumber(minutes))\(String.localized(.dateMinutes)) "
        }
        result += "\(padNumber(seconds))\(String.localized(.dateSeconds))"
        return result
    }
    
    var formattedStartUptime: String {
        formatDate(scriptStartTime)
    }

    var formattedBoottime: String? {
        guard let time = systemBootTime else { return nil }
        return formatDate(time)
    }

    var formattedEndtime: String {
        guard let data = scriptEndTime else { return ""}
        return " " + formatDate(data)
    }
    
    private func padNumber(_ number: Int) -> String {
        return String(format: "%02d", number)
    }

    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let at: String = .localized(.dateAt)

        if calendar.isDateInToday(scriptStartTime) {
            formatter.dateFormat = "'\(String.localized(.dateToday)) \(at)' HH:mm:ss"
        } else if calendar.isDateInYesterday(scriptStartTime) {
            formatter.dateFormat = "'\(String.localized(.dateYesterday)) \(at)' HH:mm:ss"
        } else {
            formatter.dateFormat = "dd/MM/yyyy '\(at)' HH:mm:ss"
        }
        
        return formatter.string(from: date)
    }
}

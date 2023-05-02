//
//  LogItemInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

fileprivate let fullLog = """
version: 4
ended: 2023-04-17_00-13-43
sysversion: 13.4
batery: 72%
charging: false
boottime: 1681697439
activetime: 3600
uptime: 3784
logprocessinterval: 1

"""

struct LogItemInfo: Identifiable {
    static let shutdownAllowed = "shutdown allowed"
    static let shutdownUnexpected = "shutdown unexpected"
    static let editedLog = "manually: "
    static let empty = LogItemInfo(fileName: "", content: "")
    static let fullUnexpected = LogItemInfo(fileName: "log_2023-04-17_00-13-40.txt", content: fullLog + "logprocess: true")
    static let fullNormal = LogItemInfo(fileName: "log_2023-05-17_00-11-40.txt", content: fullLog + shutdownAllowed)

    let id = UUID()
    let fileName: String
    var version: Int = 1

    var edited: Bool = false
    var shutdownAllowed: Bool = false
    var scriptStartTime: Date = Date.distantPast
    var scriptEndTime: Date? = nil

    var hasProcess: Bool = false
    var logProcessInterval: Int? = nil

    var systemVersion: String? = nil
    var systemBootTime: Date? = nil
    var systemUptime: TimeInterval? = nil
    var systemActivetime: TimeInterval? = nil
    var batery: Int? = nil
    var charging: Bool? = nil

    init(fileName: String = "", content: String = "") {
        self.fileName = fileName
        let lines = content.components(separatedBy: "\n")
        let formatter = DateFormatter()
        var autoShuwDownAllowed = false
        var edition: String? = nil

        //# init from file name
        formatter.dateFormat = "'log_'yyyy-MM-dd_HH-mm-ss'.txt'"
        if let date = formatter.date(from: fileName) {
            self.scriptStartTime = date
        }
        
        //# LOG V4
        lines.forEach { line in
            switch true {
            //# version: [0-9]+
            case line.hasPrefix("version: "):
                version = extractNumber(line, 1)
            //# ended: %Y-%m-%d_%H-%M-%S
            case line.hasPrefix("ended: "):
                scriptEndTime = extractScriptEndTime(from: line, formatter: formatter)
            //# sysversion: String
            case line.hasPrefix("sysversion: "):
                systemVersion = line.components(separatedBy: ": ").last
            //# batery: [0-9]+%
            case line.hasPrefix("batery: "):
                extractNumber(line).guard { batery = $0 }
            //# charging: true/false
            case line.hasPrefix("charging: "):
                charging = line.contains("true") ? true : line.contains("false") ? false : nil
            //# boottime: [0-9]+ (timestamp)
            case line.hasPrefix("boottime: "):
                extractNumber(line).guard { systemBootTime = Date.init(timeIntervalSince1970: Double($0)) }
            //# uptime: [0-9]+ (seconds interval)
            case line.hasPrefix("uptime: "):
                extractNumber(line).guard { systemUptime = TimeInterval($0) }
            //# activetime: [0-9]+
            case line.hasPrefix("activetime: "):
                extractNumber(line).guard { systemActivetime = TimeInterval($0) }
            //# logprocessinterval: [0-9]+
            case line.hasPrefix("logprocessinterval: "):
                logProcessInterval = extractNumber(line)
            //# logprocess: true/false
            case line.hasPrefix("logprocess: "):
                hasProcess = line.contains("true")
            case line == LogItemInfo.shutdownAllowed:
                autoShuwDownAllowed = true
            case line.hasPrefix(LogItemInfo.editedLog):
                edition = line.replacingOccurrences(of: LogItemInfo.editedLog, with: "")
            default: break;
            }
        }

        // Extract shutdown allowed
        if lines.first(where: { $0.hasPrefix(LogItemInfo.editedLog + LogItemInfo.shutdownUnexpected) }) != nil {
            self.shutdownAllowed = false
        } else {
            self.shutdownAllowed = lines.first(where: {$0.hasSuffix(LogItemInfo.shutdownAllowed)}) != nil
        }
        
        // Extract Edited
        edited = edition != nil && edition != (autoShuwDownAllowed ? LogItemInfo.shutdownAllowed : LogItemInfo.shutdownUnexpected)

        // Extract uptime older versions
        if let uptimeString = lines.first(where: {
            $0.hasPrefix("last record:") || // V0
            $0.hasPrefix("lastrecord:")     // V1
        })?.components(separatedBy: ": ").last {
            self.systemUptime = fromOldVersion(uptimeString)
        }
    }
    
    private func extractNumber(_ line: String, _ defaultNumber: Int) -> Int {
        return extractNumber(line) ?? defaultNumber
    }

    private func extractNumber(_ line: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
        let numbers = regex.stringByReplacingMatches(in: line, range: NSRange(location: 0, length: line.count), withTemplate: "")
        return Int(numbers)
    }
    
    private func extractScriptEndTime(from line: String, formatter: DateFormatter) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        guard let endTimeString = line.components(separatedBy: ": ").last else { return nil }
        return formatter.date(from: endTimeString)
    }

    private func fromOldVersion(_ uptimeString: String) -> TimeInterval? {
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

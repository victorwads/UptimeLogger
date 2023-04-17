//
//  LogItemInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

struct LogItemInfo: Identifiable {
    static let shutdownAllowed = "shutdown allowed"
    static let shutdownUnexpected = "shutdown unexpected"
    static let editedLog = "manually: "

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
    var batery: Int? = nil
    var charging: Bool? = nil

    init(fileName: String = "", content: String = "") {
        self.fileName = fileName
        let lines = content.components(separatedBy: "\n")
        let formatter = DateFormatter()
        var autoShuwDownAllowed = false
        var edition: String? = nil

        //# init: %Y-%m-%d_%H-%M-%S
        formatter.dateFormat = "'log_'yyyy-MM-dd_HH-mm-ss'.txt'"
        if let date = formatter.date(from: fileName) {
            self.scriptStartTime = date
        }
        
        //# LOG V4
        lines.forEach { line in
            switch true {
            //# version: [0-9]+
            case line.hasPrefix("version:"):
                version = extractNumber(line, 1)
            //# ended: %Y-%m-%d_%H-%M-%S
            case line.hasPrefix("ended:"):
                scriptEndTime = extractScriptEndTime(from: line, formatter: formatter)
            //# sysversion: String
            case line.hasPrefix("sysversion:"):
                systemVersion = line.components(separatedBy: ": ").last
            //# batery: [0-9]+%
            case line.hasPrefix("batery:"):
                batery = extractNumber(line, 1)
            //# charging: true/false
            case line.hasPrefix("charging:"):
                charging = line.contains("true")
            //# boottime: [0-9]+ (timestamp)
            case line.hasPrefix("boottime:"):
                systemBootTime = Date.init(timeIntervalSince1970: Double(extractNumber(line, 1)))
            //# uptime: [0-9]+ (seconds interval)
            case line.hasPrefix("uptime:"):
                systemUptime = TimeInterval(extractNumber(line, 0))
            //# logprocessinterval: [0-9]+
            case line.hasPrefix("logprocessinterval:"):
                logProcessInterval = extractNumber(line, 1)
            //# logprocess: true/false
            case line.hasPrefix("logprocess:"):
                hasProcess = line.contains("true")
            case line == LogItemInfo.shutdownAllowed:
                autoShuwDownAllowed = true
            case line.hasPrefix(LogItemInfo.editedLog):
                edition = line.replacingOccurrences(of: LogItemInfo.editedLog, with: "")
            default: true
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
        let regex = try! NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
        let numbers = regex.stringByReplacingMatches(in: line, range: NSRange(location: 0, length: line.count), withTemplate: "")
        return Int(numbers) ?? defaultNumber
    }
    
    private func extractScriptEndTime(from line: String, formatter: DateFormatter) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let endTimeString = line.components(separatedBy: ": ").last
        return formatter.date(from: endTimeString ?? "")
    }

    private func fromOldVersion(_ uptimeString: String?) -> TimeInterval {
        let parts = uptimeString?.components(separatedBy: ", ")
        let dayPart = parts?.first(where: {$0.contains("days")})?.replacingOccurrences(of: " days", with: "") ?? "0"
        let timeParts = parts?.last?.components(separatedBy: ":").compactMap({ Int($0) }) ?? []
        
        if timeParts.count < 3 {
            return TimeInterval(0)
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
            result += "\(days) days, "
        }
        if hours > 0 || days > 0 {
            result += "\(hours) hours, "
        }
        if minutes > 0 || hours > 0 || days > 0 {
            result += "\(minutes) minutes, "
        }
        result += "\(seconds) seconds"
        return result
    }
    
    var formattedStartUptime: String {
        return formatDate(scriptStartTime)
    }

    var formattedBoottime: String? {
        if let time = systemBootTime {
            return formatDate(time)
        }
        return nil
    }

    var formattedShutdownTime: String? {
        if let time = scriptEndTime {
            return formatDate(time)
        }
        return nil
    }
    
    var formattedEndtime: String {
        if let data = scriptEndTime {
            return " " + formatDate(data)
        } else {
            return ""
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let at = Strings.dateAt.result

        if calendar.isDateInToday(scriptStartTime) {
            formatter.dateFormat = "'\(Strings.dateToday.result) \(at)' HH:mm:ss"
        } else if calendar.isDateInYesterday(scriptStartTime) {
            formatter.dateFormat = "'\(Strings.dateYesterday.result) \(at)' HH:mm:ss"
        } else {
            formatter.dateFormat = "dd/MM/yyyy '\(at)' HH:mm:ss"
        }
        
        return formatter.string(from: date)
    }
}

//
//  LogItemInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

struct LogItemInfo: Identifiable {
    let id = UUID()
    let fileName: String
    let version: Int

    var shutdownAllowed: Bool = false
    var startUpTime: Date = Date.distantPast
    var endTime: Date? = nil
    var uptimeInSeconds: TimeInterval = 0

    init(fileName: String = "", content: String = "") {
        self.fileName = fileName
        let lines = content.components(separatedBy: "\n")
        let formatter = DateFormatter()

        // Extract Version
        let version = lines.first(where: { $0.hasPrefix("version: ") })?.components(separatedBy: " ").last ?? ""
        self.version = Int(version) ?? 0
        
        // Extract startUpTime
        formatter.dateFormat = "'log_'yyyy-MM-dd_HH-mm-ss'.txt'"
        if let date = formatter.date(from: fileName) {
            self.startUpTime = date
        }

        // Extract endTime
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        if let endTimeString = lines.first(where: {
            $0.hasPrefix("ended:") // V2
        })?.components(separatedBy: ": ").last,
        let date = formatter.date(from: endTimeString) {
            self.endTime = date
        }

        // Extract shutdown allowed
        self.shutdownAllowed = lines.first(where: { $0.hasPrefix("shutdown allowed") }) != nil
        
        // Extract uptime from file content
        if let uptimeString = lines.first(where: {
            $0.hasPrefix("uptime:") // V2
        })?.components(separatedBy: ": ").last {
            uptimeInSeconds = TimeInterval(Int(uptimeString) ?? 0)
            return
        }

        // Extract uptime older versions
        let uptimeString = lines.first(where: {
            $0.hasPrefix("last record:") || // V0
            $0.hasPrefix("lastrecord:")     // V1
        })?.components(separatedBy: ": ").last
        uptimeInSeconds = fromOldVersion(uptimeString)

    }
    
    private func fromOldVersion(_ uptimeString: String?) -> TimeInterval {
        let parts = uptimeString?.components(separatedBy: ", ")
        let dayPart = parts?.first?.replacingOccurrences(of: " days", with: "") ?? "0"
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
        let totalSeconds = Int(self.uptimeInSeconds)
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
        return formatDate(startUpTime)
    }
    
    var formattedEndtime: String {
        if let data = endTime {
            return " " + formatDate(data)
        } else {
            return ""
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let at = Strings.dateAt.value

        if calendar.isDateInToday(startUpTime) {
            formatter.dateFormat = "'\(Strings.dateToday.value) \(at)' HH:mm:ss"
        } else if calendar.isDateInYesterday(startUpTime) {
            formatter.dateFormat = "'\(Strings.dateYesterday.value) \(at)' HH:mm:ss"
        } else {
            formatter.dateFormat = "dd/MM/yyyy '\(at)' HH:mm:ss"
        }
        
        return formatter.string(from: date)
    }
}

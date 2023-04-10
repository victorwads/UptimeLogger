//
//  LogItemInfo.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

struct LogItemInfo: Identifiable {
    let id = UUID()
    let startUpTime: Date
    let uptimeInSeconds: TimeInterval
    let shutdownAllowed: Bool

    init(fileName: String, content: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "'log_'yyyy-MM-dd_HH-mm-ss'.txt'"

        // Extract start up date and time from file name
        if let date = formatter.date(from: fileName) {
            self.startUpTime = date
        } else {
            self.startUpTime = Date.distantPast
        }

        let lines = content.components(separatedBy: "\n")
        // Extract shutdown allowed
        shutdownAllowed = lines.first(where: { $0.hasPrefix("shutdown allowed") }) != nil
        
        // Extract uptime from file content
        let uptimeString = lines.first(where: { $0.hasPrefix("last record:") })?
            .replacingOccurrences(of: "last record: ", with: "")
        
        let dayPart: String = uptimeString?.components(separatedBy: ", ").first?
            .replacingOccurrences(of: " days", with: "") ?? "0"

        let timeParts = uptimeString?
            .components(separatedBy: ", ").last?
            .components(separatedBy: ":").compactMap({ Int($0) }) ?? []
        
        if timeParts.count < 3 {
            self.uptimeInSeconds = TimeInterval(0)
            return
        }
        
        let day = Int(dayPart) ?? 0
        let days: Int = day * 86400
        let hours: Int = timeParts[0] * 3600
        let minutes: Int = timeParts[1] * 60
        let seconds: Int = timeParts[2]

        self.uptimeInSeconds = TimeInterval( days + hours + minutes + seconds )
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
        let calendar = Calendar.current
        let formatter = DateFormatter()

        if calendar.isDateInToday(startUpTime) {
            formatter.dateFormat = "'Today at' HH:mm:ss"
        } else if calendar.isDateInYesterday(startUpTime) {
            formatter.dateFormat = "'Yesterday at' HH:mm:ss"
        } else {
            formatter.dateFormat = "dd/MM/yyyy 'at' HH:mm:ss"
        }
        
        return formatter.string(from: startUpTime)
    }
}

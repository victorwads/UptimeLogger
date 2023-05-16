//
//  TimeInterval+Extension.swift
//  UptimeLogger
//
//  Created by Victor Wads on 16/05/23.
//

import Foundation

extension Int {
    
    func padNumber(_ number: Int) -> String {
        return String(format: "%02d", number)
    }

    func formatInterval() -> String {
        let totalSeconds = self
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

}

extension TimeInterval {
    func formatInterval() -> String {
        return Int(self).formatInterval()
    }
}

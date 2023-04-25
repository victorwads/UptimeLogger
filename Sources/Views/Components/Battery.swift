//
//  Battery.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct Battery: View {
    enum BatteryIcon: String {
        case battery0 = "battery.0"
        case battery25 = "battery.25"
        case battery50 = "battery.50"
        case battery75 = "battery.75"
        case battery100 = "battery.100"
        
        static func fromBatteryLevel(_ level: Int) -> BatteryIcon {
            switch level {
            case 0...10:
                return .battery0
            case 11...35:
                return .battery25
            case 36...60:
                return .battery50
            case 61...85:
                return .battery75
            default:
                return .battery100
            }
        }
    }
    
    let level: Int
    
    var body: some View {
        HStack {
            Image(systemName: BatteryIcon.fromBatteryLevel(level).rawValue)
                .foregroundColor(.accentColor)
            Text("\(level)%")
        }
    }
}

struct Battery_Previews: PreviewProvider {
    static var previews: some View {
        Battery(level: 5)
        Battery(level: 15)
        Battery(level: 25)
        Battery(level: 35)
        Battery(level: 45)
        Battery(level: 55)
        Battery(level: 70)
        Battery(level: 80)
        Battery(level: 90)
        Battery(level: 100)
    }
}

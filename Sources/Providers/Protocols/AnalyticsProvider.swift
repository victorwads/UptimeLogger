//
//  AnalyticsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 25/04/23.
//

import Foundation

protocol AnalyticsProvider {
    
    func screen(_ name: String,_ class: String)
    func event(_ eventName: String, _ name: String, _ text: Any)
    
}

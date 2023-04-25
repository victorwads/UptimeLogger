//
//  AnalyticsProvider+Mock.swift
//  UptimeLogger
//
//  Created by Victor Wads on 25/04/23.
//

import Foundation

class AnalyticsProviderMock: AnalyticsProvider {
    
    func screen(_ name: String, _ class: String) {}
    
    func event(_ eventName: String, _ name: String, _ text: Any) {}
    
}

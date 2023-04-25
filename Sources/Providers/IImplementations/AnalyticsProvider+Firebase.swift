//
//  AnalyticsProvider+Firebase.swift
//  UptimeLogger
//
//  Created by Victor Wads on 25/04/23.
//

import Foundation
import FirebaseAnalytics

class AnalyticsProviderFirebase: AnalyticsProvider {
    
    func screen(_ name: String, _ className: String) {
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: name,
                AnalyticsParameterScreenClass: className
            ]
        )
    }
    
    func event(_ eventName: String, _ name: String, _ text: Any) {
        Analytics.logEvent(eventName, parameters: [
          "name": name,
          "full_text": String(describing: text)
        ])
    }
    
}

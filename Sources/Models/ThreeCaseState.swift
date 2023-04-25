//
//  ThreeCaseState.swift
//  UptimeLogger
//
//  Created by Victor Wads on 24/04/23.
//

import Foundation

enum ThreeCaseState {
    case all
    case yes
    case no
    
    var bool: Bool? { switch self {
    case .all: return nil
    case .yes: return true
    case .no: return false
    }}
}

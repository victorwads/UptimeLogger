//
//  KotlinExtensions.swift
//  UptimeLogger
//
//  Created by Victor Wads on 26/04/23.
//

import Foundation

// Implementins Kotlin Like ?.let to guard optional values
extension Optional {
    func `guard`(_ defaultValue: Wrapped? = nil, _ transform: (_ it: Wrapped) -> Any) {
        switch self {
        case .some(let value):
            _ = transform(value)
        case .none:
            if let defaultValue = defaultValue {
                _ = transform(defaultValue)
            }
        }
    }
}

extension Sequence where Element: OptionalType {
    func filterNonNil() -> [Element.Wrapped] {
        return self.compactMap { $0.optional }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    var optional: Wrapped? {
        return self
    }
}

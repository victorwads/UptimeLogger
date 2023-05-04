//
//  KotlinExtensions.swift
//  UptimeLogger
//
//  Created by Victor Wads on 26/04/23.
//

import Foundation

// Implementins Kotlin Like ?.let to guard optional values
extension Optional {
    func `let`<T>(_ defaultValue: Wrapped? = nil, _ transform: (_ it: Wrapped) -> T?) -> T? {
        switch self {
        case .some(let value):
            return transform(value)
        case .none:
            if let defaultValue = defaultValue {
                return transform(defaultValue)
            }
        }
        return nil
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

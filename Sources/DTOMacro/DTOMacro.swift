import DTOTypes
// The Swift Programming Language
// https://docs.swift.org/swift-book
/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
// @freestanding(expression)
// public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "DTOMacroMacros", type: "StringifyMacro")

import Foundation
public extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        if contains(".") {
            formatter.formatOptions.insert(.withFractionalSeconds)
        }
        return formatter.date(from: self)
    }
}

@attached(conformance)
@attached(member, names: arbitrary)
public macro DecodableFromDTO() = #externalMacro(module: "DTOMacroMacros", type: "DecodableFromDTOMacro")

@attached(member, names: arbitrary)
public macro ConvertDTOType<SourceType, DestinationType>(from:SourceType.Type, to: DestinationType.Type, convert: (SourceType)->DestinationType) = #externalMacro(module: "DTOMacroMacros", type: "ConvertDTOMacro")

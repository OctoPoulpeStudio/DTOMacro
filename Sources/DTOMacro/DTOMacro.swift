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

@attached(conformance)
public macro DecodableFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "DecodableFromDTOMacro")

@attached(peer)
public macro ConvertDTOType<SourceType, DestinationType>(from:SourceType.Type, to: DestinationType.Type, convert: (SourceType)->DestinationType) = #externalMacro(module: "DTOMacrosImpl", type: "ConvertDTOMacro")

@attached(peer)
public macro ConvertFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "ConvertFromDTOMacro")

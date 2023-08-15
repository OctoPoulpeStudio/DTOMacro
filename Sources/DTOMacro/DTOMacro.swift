import DTOTypes
import DTOMacrosImpl

@attached(extension, conformances: DecodableFromDTOProtocol, names: named(DTO),named(DTOConversionProcessor), named(init(from:)))
public macro DecodableFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "DecodableFromDTOMacro")

@attached(peer)
public macro ConvertDTOType<SourceType, DestinationType>(from:SourceType.Type, to: DestinationType.Type, convert: (SourceType)->DestinationType) = #externalMacro(module: "DTOMacrosImpl", type: "ConvertDTOMacro")

@attached(peer)
public macro ConvertFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "ConvertFromDTOMacro")

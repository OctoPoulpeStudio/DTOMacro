//
//  DTORule.swift
//  
//
//  Created by la pieuvre on 06/08/2023.
//
public protocol DTORuleProtocol {
    var sourceType: String { get }
    var destinationType: String { get }
    func applyTransform(to object: Any) -> Any
}

public struct DTORule<SourceType, DestinationType>: DTORuleProtocol {
    public let sourceType: String = String(describing: type(of: SourceType.self))
    public let destinationType:String = String(describing: type(of: DestinationType.self))
    public let transform: (SourceType) -> DestinationType
    public init(transform: @escaping (SourceType) -> DestinationType) {
        self.transform = transform
    }
    
    public func applyTransform(to object: Any) -> Any {
        guard let sourceObject = object as? SourceType else { return object }
        return transform(sourceObject)
    }
}

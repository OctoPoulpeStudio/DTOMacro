//
//  DTOError.swift
//  
//
//  Created by la pieuvre on 13/08/2023.
//

import Foundation
import SwiftDiagnostics

public enum DTODiagnostic: String, DiagnosticMessage {
    case DTOConvertFromNotOnVariableError
    case DTOConvertFromTypeDontMatchError
    
    case DTOConvertFromTypeDontMatchErrorPropertyTypeNil
    case DTOConvertFromTypeDontMatchErrorAttributeNodeNil
    case DTOConvertFromTypeDontMatchErrorDestTypeNodeNil
    
    public var diagnosticID: MessageID {
        MessageID(domain: "DTOMacro", id: rawValue)
    }
    
    public var severity: DiagnosticSeverity {return .error}
    
    public static var obj:String = ""
    
    public var message: String {
        switch self {
            case .DTOConvertFromNotOnVariableError:
                return "@ConvertDTOType attribute must only be applied to a 'stored property'."
            case .DTOConvertFromTypeDontMatchError:
                return "@ConvertDTOType attribute 'to' parameter must match the property type."
            case .DTOConvertFromTypeDontMatchErrorPropertyTypeNil:
                return "@ConvertDTOType attribute PropertyTypeNil"
            case .DTOConvertFromTypeDontMatchErrorAttributeNodeNil:
                return "@ConvertDTOType attribute AttributeNodeNil"
            case .DTOConvertFromTypeDontMatchErrorDestTypeNodeNil:
                return "@ConvertDTOType attribute DestTypeNodeNil \(Self.obj)"
        }
    }
}

public struct FixDestTypeMessage: FixItMessage {
    private let attributeType: String
    private let propertyType: String
    public var message: String {
        "Replace type: \(attributeType) by type: \(propertyType)"
    }
    public var fixItID: MessageID = MessageID(domain: "com.octopoulpe.dtoMacro", id: "FixConvertToType")
    
    init(attributeType: String?, propertyType: String?) {
        self.attributeType = attributeType ?? "nil"
        self.propertyType = propertyType ?? "nil"
    }
}

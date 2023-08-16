// MIT License
//
// Copyright (c) 2023 OctoPoulpe Studio
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

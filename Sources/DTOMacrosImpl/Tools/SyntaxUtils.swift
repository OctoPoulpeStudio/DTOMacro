//
//  SyntaxUtils.swift
//  
//
//  Created by la pieuvre on 12/08/2023.
//

import SwiftSyntax
internal typealias SU = SyntaxUtils
internal struct SyntaxUtils {
    internal static func get(attributeNamed name: String, in varDecl: VariableDeclSyntax) -> AttributeSyntax? {
        varDecl.attributes?.filter({filter(attributeNamed: name, element: $0)}).first?.as(AttributeSyntax.self)
    }
    internal static func has(attributeNamed name:String , in varDecl: VariableDeclSyntax) -> Bool {
        return !(varDecl.attributes?.filter{filter(attributeNamed: name, element: $0)}.isEmpty ?? true)
    }
    
    internal static func filter(attributeNamed name:String, element: AttributeListSyntax.Element) -> Bool {
        guard let attribute = element.as(AttributeSyntax.self) else { return false}
        return attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text == name
    }
    
    internal static func convert(exprSyntax: ExprSyntaxProtocol) -> TypeAnnotationSyntax? {
        return TypeAnnotationSyntax(type: TypeSyntax("\(raw: exprSyntax)"))
    }
    
    internal static func getParameterValue(in arguments: LabeledExprListSyntax, for id:String) -> ExprSyntax? {
        guard let toArgument = arguments.first(where: { tupleExprElementSyntax in tupleExprElementSyntax.label?.text == id }) else {return nil}
        return toArgument.expression
    }
    
}

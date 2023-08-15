//
//  DiagnosticBuilder.swift
//  
//
//  Created by la pieuvre on 14/08/2023.
//
import SwiftSyntax
import SwiftDiagnostics

public enum DiagnosticBuilder {
    public static func buildTypeError(for variableSyntax: VariableDeclSyntax) -> Diagnostic {
        guard let propertyType = variableSyntax.bindings.first?.typeAnnotation?.as(TypeAnnotationSyntax.self),
              let attributeNode = SU.get(attributeNamed: MacroName.ConvertDTOType, in: variableSyntax),
              //let destNode = MacroUtils.getConvertDestinationTypeOrignialNode(in: attributeNode),
              let destTypeNode = MacroUtils.getConvertDestinationType(in: attributeNode)
        else {return Diagnostic(node: variableSyntax, message: DTODiagnostic.DTOConvertFromTypeDontMatchErrorDestTypeNodeNil)}
        
        let fixIt = [FixIt(
            message: FixDestTypeMessage(
                attributeType: destTypeNode.type.description,
                propertyType: propertyType.type.description
            ),
            changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(destTypeNode),
                    newNode: Syntax(propertyType.type)
                )
            ]
        )]

        return Diagnostic(
            node: variableSyntax,
            message: DTODiagnostic.DTOConvertFromTypeDontMatchError,
            fixIts: fixIt
        )
    }
}

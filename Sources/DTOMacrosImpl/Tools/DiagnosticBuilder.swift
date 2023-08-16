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

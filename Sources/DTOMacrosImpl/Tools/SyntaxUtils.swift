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

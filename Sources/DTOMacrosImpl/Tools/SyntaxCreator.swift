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
//  SyntaxCreator.swift
//  
//
//  Created by la pieuvre on 12/08/2023.
//

import SwiftSyntax

internal typealias SC = SyntaxCreator
internal struct SyntaxCreator {
    internal static func create(name:String) -> TokenSyntax {
        TokenSyntax(stringLiteral: name)
    }
    
    internal static func createExtension(ofType type: some TypeSyntaxProtocol, withProtocol exProtocol: [String] , members: [MemberBlockItemSyntax]) -> ExtensionDeclSyntax {
        return ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: SC.createInheritanceClause(types: exProtocol),
            memberBlock: MemberBlockSyntax(
                members: MemberBlockItemListSyntax(members)
            )
        )
    }
    
    internal static func createInitSignature(with paramters:[FunctionParameterSyntax]) -> FunctionSignatureSyntax{
        FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                parameters:
                    FunctionParameterListSyntax([
                        FunctionParameterSyntax(firstName: SyntaxCreator.create(name: "from"), secondName: SyntaxCreator.create(name: DTOTokenName.dto), type: IdentifierTypeSyntax(name:DTOTokenSyntax.DTO))
                    ])
            )
        )
    }
    internal static func createClosureCallParamters(withName name: String) -> ClosureSignatureSyntax.ParameterClause{
        return createClosureCallParamters(withNames: [name])
    }
    
    internal static func createClosureCallParamters(withNames names: [String]) -> ClosureSignatureSyntax.ParameterClause{
        let params = names.map { name in
            ClosureParameterSyntax(firstName: TokenSyntax(stringLiteral: name))
        }
        return ClosureSignatureSyntax.ParameterClause(ClosureParameterClauseSyntax(parameters: ClosureParameterListSyntax(params)))
    }
    
    internal static func createFuncParam(label: String, paramName:String? = nil, type: String) -> FunctionParameterSyntax {
        FunctionParameterSyntax(firstName: SyntaxCreator.create(name: label), secondName: paramName.map{SyntaxCreator.create(name: $0)}, type: IdentifierTypeSyntax(name:"\(raw: type)"))
    }
    
    internal static func createInitMethod(accessor: Keyword, parameters: [FunctionParameterSyntax], statements: [CodeBlockItemSyntax]) -> MemberBlockItemSyntax {
        MemberBlockItemSyntax(decl: InitializerDeclSyntax(
            modifiers: SC.createAccessor(accessor),
            signature: SC.createInitSignature(with: parameters),
            body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(statements))
        ))
    }
    
    internal static func createAccessor(_ accessibility:Keyword) -> DeclModifierListSyntax? {
        DeclModifierListSyntax{[
            DeclModifierSyntax(name: "\(raw:accessibility)")
        ]}
    }
    internal static func createAccessors(_ accessors:[Keyword]) -> DeclModifierListSyntax? {
        DeclModifierListSyntax{
            for accessor in accessors {
                DeclModifierSyntax(name: "\(raw:accessor)")
            }
        }
    }
    
    internal static func createInheritanceClause(types: [String]) -> InheritanceClauseSyntax? {
        guard !types.isEmpty else {return nil}
        return InheritanceClauseSyntax(
            inheritedTypes: InheritedTypeListSyntax(
                types.map{
                    InheritedTypeSyntax(type:TypeSyntax(stringLiteral: $0))
                }
            )
        )
    }
    
    internal static func createVariableDecl(accessor: Keyword, isVar:Bool = false, name:String, type:TypeAnnotationSyntax, value:ExprSyntaxProtocol? = nil) -> VariableDeclSyntax {
        VariableDeclSyntax(modifiers: SC.createAccessor(accessor), isVar ? .var : .let, name: PatternSyntax(stringLiteral: name), type: type, initializer: value.map{InitializerClauseSyntax(value: $0)})
    }
    
    internal static func createVariableDecl(accessors: [Keyword], isVar:Bool = false, name:String, type:TypeAnnotationSyntax, value:ExprSyntaxProtocol? = nil) -> VariableDeclSyntax {
        
        VariableDeclSyntax(modifiers: SC.createAccessors(accessors), isVar ? .var : .let, name: PatternSyntax(stringLiteral: name), type: type, initializer: value.map{InitializerClauseSyntax(value: $0)})
    }
    
    internal static func createStruct(accessor: Keyword, typeName:String, members: MemberBlockItemListSyntax, types:[String] = []) -> MemberBlockItemSyntax{
        MemberBlockItemSyntax(decl: StructDeclSyntax(
            modifiers: SC.createAccessor(accessor),
            name: "\(raw: typeName)",
            inheritanceClause: SC.createInheritanceClause(types: types) ,
            memberBlock: MemberBlockSyntax(members: members)))
    }
    
    internal static func createInitAssignment(forVarNamed name: String, value: String) -> CodeBlockItemSyntax{
        CodeBlockItemSyntax(stringLiteral:
            "self.\(name) = \(value)"
        )
    }
    
    internal static func createClosure(parameterTypes: [TypeAnnotationSyntax], returnType: TypeAnnotationSyntax) -> FunctionTypeSyntax {
        let parameters = parameterTypes.map{ type in
            TupleTypeElementSyntax(type: type.type)
        }
        return FunctionTypeSyntax(
            parameters: TupleTypeElementListSyntax(parameters),
            returnClause: ReturnClauseSyntax(type: returnType.type)
        )
    }
    
    internal static func createClosureType(parameterTypes: [TypeAnnotationSyntax], returnType: TypeAnnotationSyntax) -> TypeAnnotationSyntax {
        return TypeAnnotationSyntax(type: createClosure(parameterTypes: parameterTypes, returnType: returnType))
    }
}

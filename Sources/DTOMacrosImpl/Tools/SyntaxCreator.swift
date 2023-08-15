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
                        FunctionParameterSyntax(firstName: SyntaxCreator.create(name: "from"), secondName: SyntaxCreator.create(name: "dto"), type: IdentifierTypeSyntax(name:"DTO"))
                    ])
            )
        )
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

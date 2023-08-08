import DTOTypes
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

//StructDeclSyntax
//├─attributes: AttributeListSyntax
//│ ╰─[0]: AttributeSyntax
//│   ├─atSignToken: atSign
//│   ╰─attributeName: SimpleTypeIdentifierSyntax
//│     ╰─name: identifier("DecodableFromDTO")
//├─modifiers: ModifierListSyntax
//│ ╰─[0]: DeclModifierSyntax
//│   ╰─name: keyword(SwiftSyntax.Keyword.public)
//├─structKeyword: keyword(SwiftSyntax.Keyword.struct)
//├─identifier: identifier("SomeDataM")
//╰─memberBlock: MemberDeclBlockSyntax
//    ├─leftBrace: leftBrace
//    ├─members: MemberDeclListSyntax
//    │ ├─[0]: MemberDeclListItemSyntax
//    │ │ ╰─decl: VariableDeclSyntax
//    │ │   ├─modifiers: ModifierListSyntax
//    │ │   │ ╰─[0]: DeclModifierSyntax
//    │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.public)
//    │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
//    │ │   ╰─bindings: PatternBindingListSyntax
//    │ │     ╰─[0]: PatternBindingSyntax
//    │ │       ├─pattern: IdentifierPatternSyntax
//    │ │       │ ╰─identifier: identifier("name")
//    │ │       ╰─typeAnnotation: TypeAnnotationSyntax
//    │ │         ├─colon: colon
//    │ │         ╰─type: SimpleTypeIdentifierSyntax
//    │ │           ╰─name: identifier("String")
//    │ ├─[1]: MemberDeclListItemSyntax
//    │ │ ╰─decl: VariableDeclSyntax
//    │ │   ├─attributes: AttributeListSyntax
//    │ │   │ ╰─[0]: AttributeSyntax
//    │ │   │   ├─atSignToken: atSign
//    │ │   │   ├─attributeName: SimpleTypeIdentifierSyntax
//    │ │   │   │ ╰─name: identifier("ConvertDTOType")
//    │ │   │   ├─leftParen: leftParen
//    │ │   │   ├─argument: TupleExprElementListSyntax
//    │ │   │   │ ├─[0]: TupleExprElementSyntax
//    │ │   │   │ │ ├─label: identifier("from")
//    │ │   │   │ │ ├─colon: colon
//    │ │   │   │ │ ├─expression: IdentifierExprSyntax
//    │ │   │   │ │ │ ╰─identifier: identifier("String")
//    │ │   │   │ │ ╰─trailingComma: comma
//    │ │   │   │ ├─[1]: TupleExprElementSyntax
//    │ │   │   │ │ ├─label: identifier("to")
//    │ │   │   │ │ ├─colon: colon
//    │ │   │   │ │ ├─expression: OptionalChainingExprSyntax
//    │ │   │   │ │ │ ├─expression: IdentifierExprSyntax
//    │ │   │   │ │ │ │ ╰─identifier: identifier("Date")
//    │ │   │   │ │ │ ╰─questionMark: postfixQuestionMark
//    │ │   │   │ │ ╰─trailingComma: comma
//    │ │   │   │ ╰─[2]: TupleExprElementSyntax
//    │ │   │   │   ├─label: identifier("convert")
//    │ │   │   │   ├─colon: colon
//    │ │   │   │   ╰─expression: ClosureExprSyntax
//    │ │   │   │     ├─leftBrace: leftBrace
//    │ │   │   │     ├─signature: ClosureSignatureSyntax
//    │ │   │   │     │ ├─input: ClosureParamListSyntax
//    │ │   │   │     │ │ ╰─[0]: ClosureParamSyntax
//    │ │   │   │     │ │   ╰─name: identifier("source")
//    │ │   │   │     │ ╰─inTok: keyword(SwiftSyntax.Keyword.in)
//    │ │   │   │     ├─statements: CodeBlockItemListSyntax
//    │ │   │   │     │ ╰─[0]: CodeBlockItemSyntax
//    │ │   │   │     │   ╰─item: FunctionCallExprSyntax
//    │ │   │   │     │     ├─calledExpression: MemberAccessExprSyntax
//    │ │   │   │     │     │ ├─base: IdentifierExprSyntax
//    │ │   │   │     │     │ │ ╰─identifier: identifier("source")
//    │ │   │   │     │     │ ├─dot: period
//    │ │   │   │     │     │ ╰─name: identifier("toDate")
//    │ │   │   │     │     ├─leftParen: leftParen
//    │ │   │   │     │     ├─argumentList: TupleExprElementListSyntax
//    │ │   │   │     │     ╰─rightParen: rightParen
//    │ │   │   │     ╰─rightBrace: rightBrace
//    │ │   │   ╰─rightParen: rightParen
//    │ │   ├─modifiers: ModifierListSyntax
//    │ │   │ ╰─[0]: DeclModifierSyntax
//    │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.public)
//    │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
//    │ │   ╰─bindings: PatternBindingListSyntax
//    │ │     ╰─[0]: PatternBindingSyntax
//    │ │       ├─pattern: IdentifierPatternSyntax
//    │ │       │ ╰─identifier: identifier("date")
//    │ │       ╰─typeAnnotation: TypeAnnotationSyntax
//    │ │         ├─colon: colon
//    │ │         ╰─type: OptionalTypeSyntax
//    │ │           ├─wrappedType: SimpleTypeIdentifierSyntax
//    │ │           │ ╰─name: identifier("Date")
//    │ │           ╰─questionMark: postfixQuestionMark
//    │ ├─[2]: MemberDeclListItemSyntax
//    │ │ ╰─decl: VariableDeclSyntax
//    │ │   ├─modifiers: ModifierListSyntax
//    │ │   │ ╰─[0]: DeclModifierSyntax
//    │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.public)
//    │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
//    │ │   ╰─bindings: PatternBindingListSyntax
//    │ │     ╰─[0]: PatternBindingSyntax
//    │ │       ├─pattern: IdentifierPatternSyntax
//    │ │       │ ╰─identifier: identifier("age")
//    │ │       ╰─typeAnnotation: TypeAnnotationSyntax
//    │ │         ├─colon: colon
//    │ │         ╰─type: SimpleTypeIdentifierSyntax
//    │ │           ╰─name: identifier("Int")
//    │ ├─[3]: MemberDeclListItemSyntax
//    │ │ ╰─decl: VariableDeclSyntax
//    │ │   ├─modifiers: ModifierListSyntax
//    │ │   │ ╰─[0]: DeclModifierSyntax
//    │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.public)
//    │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
//    │ │   ╰─bindings: PatternBindingListSyntax
//    │ │     ╰─[0]: PatternBindingSyntax
//    │ │       ├─pattern: IdentifierPatternSyntax
//    │ │       │ ╰─identifier: identifier("address")
//    │ │       ╰─typeAnnotation: TypeAnnotationSyntax
//    │ │         ├─colon: colon
//    │ │         ╰─type: SimpleTypeIdentifierSyntax
//    │ │           ╰─name: identifier("Address")
//    │ ╰─[4]: MemberDeclListItemSyntax
//    │   ╰─decl: VariableDeclSyntax
//    │     ├─modifiers: ModifierListSyntax
//    │     │ ╰─[0]: DeclModifierSyntax
//    │     │   ╰─name: keyword(SwiftSyntax.Keyword.public)
//    │     ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
//    │     ╰─bindings: PatternBindingListSyntax
//    │       ╰─[0]: PatternBindingSyntax
//    │         ├─pattern: IdentifierPatternSyntax
//    │         │ ╰─identifier: identifier("sex")
//    │         ╰─typeAnnotation: TypeAnnotationSyntax
//    │           ├─colon: colon
//    │           ╰─type: SimpleTypeIdentifierSyntax
//    │             ╰─name: identifier("String")
//    ╰─rightBrace: rightBrace

public struct ConvertDTOMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        return []
    }
    
    
}
public struct DecodableFromDTOMacro: ConformanceMacro, MemberMacro {
    private struct parsedVariableInfo {
        fileprivate let hasConvertType: Bool
        fileprivate let convertInfo: ConvertInfo?
        fileprivate let name: String
        fileprivate let type: TypeAnnotationSyntax
    }
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingConformancesOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [(SwiftSyntax.TypeSyntax, SwiftSyntax.GenericWhereClauseSyntax?)] {
        [("DecodableFromDTOProtocol", nil)]
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        return ["\(raw: declaration.debugDescription)"]
        return []
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let structDecl: StructDeclSyntax = declaration.cast(StructDeclSyntax.self)
        let membersInfo: [parsedVariableInfo] = structDecl.memberBlock.members.compactMap { member in
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  let bindings = varDecl.bindings.first,
                  let identifier = bindings.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                  let type = bindings.typeAnnotation
            else { return nil }

            return parsedVariableInfo(
                hasConvertType: hasConvertStmt(varDecl: varDecl),
                convertInfo: getConvertInfo(varDecl: varDecl),
                name: identifier.text,
                type: type
            )
        }
        
        let dtoDecl = membersInfo.compactMap { createLetDeclaration(accessor:.public, name:$0.name ,type: ($0.convertInfo?.sourceType ?? $0.type))}
        
        let result = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: createInheritanceClause("DecodableFromDTOProtocol"),
            memberBlock: MemberDeclBlockSyntax(
                members:  MemberDeclListSyntax([
                    createStruct(accessor: .public, typeName: "DTO", members: MemberDeclListSyntax(dtoDecl.compactMap({ variable in
                        MemberDeclListItemSyntax(decl: variable)
                    }))),
                    createInit(propertyInfo: membersInfo)
                ])
            )
        )
        
        return [result]
    }
    
    private static func createStruct(accessor: Keyword, typeName:String, members: MemberBlockItemListSyntax) -> MemberBlockItemSyntax{
        MemberBlockItemSyntax(decl: StructDeclSyntax(
            modifiers: createAccessorClause(accessor),
            name: TokenSyntax.identifier(typeName),
            inheritanceClause: InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax([InheritedTypeSyntax(type:TypeSyntax(stringLiteral: "Decodable"))])),
            memberBlock: MemberBlockSyntax(members: members)))
    }
    
    public static func createLetDeclaration(accessor: Keyword, name:String, type:TypeAnnotationSyntax) -> VariableDeclSyntax {
        VariableDeclSyntax(modifiers: createAccessorClause(accessor), Keyword.let, name: PatternSyntax(stringLiteral: name), type: type)
    }
    
    private static func createInheritanceClause(_ typeName:String) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax(
            inheritedTypes: InheritedTypeListSyntax([
                InheritedTypeSyntax(
                    type: TypeSyntax(stringLiteral: typeName)
                )
            ]
        ))
    }
    
    private static func createInit(propertyInfo:[parsedVariableInfo])  -> MemberBlockItemSyntax {
        var assignments = [CodeBlockItemSyntax]()
        for info in propertyInfo {
            assignments.append(CodeBlockItemSyntax(stringLiteral: "self.\(info.name) = dto.\(info.name)\(info.hasConvertType ? "// convertible" : "")"))
        }
        return MemberBlockItemSyntax(decl: InitializerDeclSyntax(
            modifiers: createAccessorClause(.public),
            signature: createInitSignature(),
            body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(assignments))
        ))
    }
    
    private static func createAccessorClause(_ accessibility:Keyword) -> DeclModifierListSyntax? {
        DeclModifierListSyntax{[
            DeclModifierSyntax(name: TokenSyntax(.keyword(.public), presence: SourcePresence.present))
        ]}
    }
    
    private static func createInitSignature() -> FunctionSignatureSyntax{
        FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters:
            FunctionParameterListSyntax([
                FunctionParameterSyntax(firstName: create(name: "from"), secondName: create(name: "dto"), type: IdentifierTypeSyntax(name:"DTO"))
            ])
        ))
    }
    
    private static func create(name:String) -> TokenSyntax {
        TokenSyntax(stringLiteral: name)
    }
    //       [1]: MemberDeclListItemSyntax
    //    │ │ ╰─decl: VariableDeclSyntax
    //    │ │   ├─attributes: AttributeListSyntax
    //    │ │   │ ╰─[0]: AttributeSyntax
    //    │ │   │   ├─atSignToken: atSign
    //    │ │   │   ├─attributeName: SimpleTypeIdentifierSyntax
    //    │ │   │   │ ╰─name: identifier("ConvertDTOType")
    //    │ │   │   ├─leftParen: leftParen
    //    │ │   │   ├─argument: TupleExprElementListSyntax
    //    │ │   │   │ ├─[0]: TupleExprElementSyntax
    //    │ │   │   │ │ ├─label: identifier("from")
    //    │ │   │   │ │ ├─colon: colon
    //    │ │   │   │ │ ├─expression: IdentifierExprSyntax
    //    │ │   │   │ │ │ ╰─identifier: identifier("String")
    //    │ │   │   │ │ ╰─trailingComma: comma
    //    │ │   │   │ ├─[1]: TupleExprElementSyntax
    //    │ │   │   │ │ ├─label: identifier("to")
    //    │ │   │   │ │ ├─colon: colon
    //    │ │   │   │ │ ├─expression: OptionalChainingExprSyntax
    //    │ │   │   │ │ │ ├─expression: IdentifierExprSyntax
    //    │ │   │   │ │ │ │ ╰─identifier: identifier("Date")
    //    │ │   │   │ │ │ ╰─questionMark: postfixQuestionMark
    //    │ │   │   │ │ ╰─trailingComma: comma
    //    │ │   │   │ ╰─[2]: TupleExprElementSyntax
    //    │ │   │   │   ├─label: identifier("convert")
    //    │ │   │   │   ├─colon: colon
    //    │ │   │   │   ╰─expression: ClosureExprSyntax
    //    │ │   │   │     ├─leftBrace: leftBrace
    //    │ │   │   │     ├─signature: ClosureSignatureSyntax
    //    │ │   │   │     │ ├─input: ClosureParamListSyntax
    //    │ │   │   │     │ │ ╰─[0]: ClosureParamSyntax
    //    │ │   │   │     │ │   ╰─name: identifier("source")
    //    │ │   │   │     │ ╰─inTok: keyword(SwiftSyntax.Keyword.in)
    //    │ │   │   │     ├─statements: CodeBlockItemListSyntax
    //    │ │   │   │     │ ╰─[0]: CodeBlockItemSyntax
    //    │ │   │   │     │   ╰─item: FunctionCallExprSyntax
    //    │ │   │   │     │     ├─calledExpression: MemberAccessExprSyntax
    //    │ │   │   │     │     │ ├─base: IdentifierExprSyntax
    //    │ │   │   │     │     │ │ ╰─identifier: identifier("source")
    //    │ │   │   │     │     │ ├─dot: period
    //    │ │   │   │     │     │ ╰─name: identifier("toDate")
    //    │ │   │   │     │     ├─leftParen: leftParen
    //    │ │   │   │     │     ├─argumentList: TupleExprElementListSyntax
    //    │ │   │   │     │     ╰─rightParen: rightParen
    //    │ │   │   │     ╰─rightBrace: rightBrace
    //    │ │   │   ╰─rightParen: rightParen
    //    │ │   ├─modifiers: ModifierListSyntax
    //    │ │   │ ╰─[0]: DeclModifierSyntax
    //    │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.public)
    //    │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.let)
    //    │ │   ╰─bindings: PatternBindingListSyntax
    //    │ │     ╰─[0]: PatternBindingSyntax
    //    │ │       ├─pattern: IdentifierPatternSyntax
    //    │ │       │ ╰─identifier: identifier("date")
    //    │ │       ╰─typeAnnotation: TypeAnnotationSyntax
    //    │ │         ├─colon: colon
    //    │ │         ╰─type: OptionalTypeSyntax
    //    │ │           ├─wrappedType: SimpleTypeIdentifierSyntax
    //    │ │           │ ╰─name: identifier("Date")
    //    │ │           ╰─questionMark: postfixQuestionMark
    private static func getConvertInfo(varDecl: VariableDeclSyntax) -> ConvertInfo?{
        guard let convertAttribute = varDecl.attributes?.filter({filterConvertDTOType(element: $0)}).first?.as(AttributeSyntax.self),
              let arguments = convertAttribute.arguments?.as(LabeledExprListSyntax.self) else {return nil}
        guard let sourceType = getConvertSourceType(in: arguments),
              let destinationType =  getConvertDestinationType(in: arguments),
              let conversionClosure = getConvertConversionClosure(in: arguments) else {return nil}
        
        return ConvertInfo(sourceType: sourceType, destinationType: destinationType, convertClosure: conversionClosure)
    }
    
    private static func getConvertSourceType(in arguments: LabeledExprListSyntax) -> ExprSyntaxProtocol? {
        return getParameterValue(in: arguments, for: "from")
    }
    
    private static func getConvertDestinationType(in arguments: LabeledExprListSyntax) -> ExprSyntaxProtocol? {
        return getParameterValue(in: arguments, for: "to")
    }
    
    private static func getConvertConversionClosure(in arguments: LabeledExprListSyntax) -> ClosureExprSyntax? {
        return getParameterValue(in: arguments, for: "convert")?.as(ClosureExprSyntax.self)
    }
    
    private static func getParameterValue(in arguments: LabeledExprListSyntax, for id:String) -> ExprSyntaxProtocol? {
        guard let toArgument = arguments.first(where: { tupleExprElementSyntax in tupleExprElementSyntax.label?.text == id }) else {return nil}
        return toArgument.expression
    }
    
    private struct ConvertInfo {
        fileprivate let sourceType: ExprSyntaxProtocol
        fileprivate let destinationType: ExprSyntaxProtocol
        fileprivate let convertClosure: ClosureExprSyntax
    }
    private static func hasConvertStmt(varDecl: VariableDeclSyntax) -> Bool {
        return !(varDecl.attributes?.filter{filterConvertDTOType(element: $0)}.isEmpty ?? true)
    }
    
    private static func filterConvertDTOType(element: AttributeListSyntax.Element) -> Bool {
        guard let attribute = element.as(AttributeSyntax.self) else { return false}
        return attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "ConvertDTOType"
    }
}

public struct DTOTransformationMacro: FreestandingMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        return []
    }
    
    
}

@main
struct DTOMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DecodableFromDTOMacro.self,
        ConvertDTOMacro.self,
    ]
}




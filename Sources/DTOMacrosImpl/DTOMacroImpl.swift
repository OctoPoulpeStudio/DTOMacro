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
import DTOTypes
import SwiftDiagnostics
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

let DefaultAccessor : Keyword = .public

public enum MacroName {
    public static let ConvertDTOType = "ConvertDTOType"
    public static let DecodableFromDTO = "DecodableFromDTO"
    public static let ConvertFromDTO = "ConvertFromDTO"
    public static let DTOPropertyName = "DTOProperty"
}

public enum DTOTokenSyntax {
    public static let DTO = TokenSyntax("DTO")
}

public enum DTOTokenName {
    public static let DTO = "DTO"
    public static let dto = "dto"
}

public struct ConvertDTOMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        for diag in MacroUtils.getDiagnostics(for: declaration.as(VariableDeclSyntax.self)!){
            context.diagnose(diag)
        }
        return []
    }
}

public struct ConvertFromDTOMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return []
    }
}

public struct DTOPropertyNameMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return []
    }
}

public struct DecodableFromDTOMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        [("DecodableFromDTOProtocol", nil)]
    }
   
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let accessor = MacroUtils.getDTOAccessor(declaration: declaration)
        
        
        let membersInfo: [ParsedVariableInfo] = convert(type: declaration, accessor: accessor)
        let (convertors, properties) = extract(from: membersInfo)
        
        for diagnostic in membersInfo.flatMap({ parsedVariableInfo in
            parsedVariableInfo.diagnostics
        }) {
            context.diagnose(diagnostic)
        }
        
        let result = SC.createExtension(
            ofType: type,
            withProtocol: ["DecodableFromDTOProtocol"],
            members: [
                SC.createStruct(accessor: .public, typeName: DTOTokenName.DTO, members: MemberBlockItemListSyntax(properties), types: ["Decodable"]),
                SC.createStruct(accessor: .private, typeName: "DTOConversionProcessor", members: MemberBlockItemListSyntax(convertors)),
                createInit(propertyInfo: membersInfo)
            ]
        )
        return [result]
    }
    
    private static func convert(type declaration: some DeclGroupSyntax, accessor: Keyword = DefaultAccessor) -> [ParsedVariableInfo] {
        guard let structDecl: StructDeclSyntax = declaration.as(StructDeclSyntax.self) else {return []}
        return structDecl.memberBlock.members.compactMap ({convert(member:$0,accessor:accessor)})
    }
    
    private static func convert(member: MemberBlockItemSyntax, accessor: Keyword = DefaultAccessor) -> ParsedVariableInfo? {
        guard let varDecl = member.decl.as(VariableDeclSyntax.self),
              let bindings = varDecl.bindings.first,
              let identifier = bindings.pattern.as(IdentifierPatternSyntax.self)?.identifier,
              let type = bindings.typeAnnotation
        else { return nil }
        
        let hasConvertDTOType = SU.has(attributeNamed: MacroName.ConvertFromDTO, in: varDecl)
        let hasConvertType = SU.has(attributeNamed: MacroName.ConvertDTOType, in: varDecl) || hasConvertDTOType
        
        return ParsedVariableInfo(
            accessor: accessor,
            hasConvertType: hasConvertType,
            convertInfo: hasConvertDTOType ? MacroUtils.getConvertDTOInfo(from: type) : MacroUtils.getConvertInfo(from: varDecl),
            businessName: identifier.text,
            dtoName: MacroUtils.getDTOPropertyName(from: varDecl),
            type: type,
            debug: "\(identifier.text) dtoName : \(String(describing: MacroUtils.getDTOPropertyName(from: varDecl)))"
        )
    }
    
    
    
    private static func extract(from membersInfo: [ParsedVariableInfo]) -> (convertors: [MemberBlockItemSyntax], properties: [MemberBlockItemSyntax]) {
        membersInfo.reduce((convertors: [MemberBlockItemSyntax](), properties: [MemberBlockItemSyntax]())) { partialResult, info in
            var convertors = partialResult.convertors
            var properties = partialResult.properties
            
            let convertor = info.convertInfo.flatMap({ convertInfo in
                SC.createVariableDecl(
                    accessors:[.fileprivate, .static],
                    isVar: true,
                    name:info.dtoName ,
                    type: SC.createClosureType(parameterTypes: [convertInfo.sourceType], returnType: info.type),
                    value: convertInfo.convertClosure
                )
            })
            
            if let convertor {
                convertors.append(MemberBlockItemSyntax(decl:convertor))
            }
            
            let property = SC.createVariableDecl(accessor:info.accessor, name:info.dtoName ,type: (info.convertInfo?.sourceType ?? info.type))
            properties.append(MemberBlockItemSyntax(decl:property))
            
            return (convertors: convertors, properties: properties)
        }
    }
    
    private static func createInit(propertyInfo:[ParsedVariableInfo])  -> MemberBlockItemSyntax {
        var assignments = [CodeBlockItemSyntax]()
        for info in propertyInfo {
            let value = info.convertInfo.map{_ in createConversionMethodCall(info)} ?? "dto." + info.dtoName
            assignments.append(SC.createInitAssignment(forVarNamed: info.businessName, value: value))
        }
        return SC.createInitMethod(
            accessor: .public ,
            parameters: [SC.createFuncParam(label: "from", paramName: DTOTokenName.dto, type: DTOTokenName.DTO)],
            statements: assignments
        )
    }
                               
    private static let createConversionMethodCall: (ParsedVariableInfo) -> String = { info in
        let processorMethodName = "DTOConversionProcessor.\(info.dtoName)"
        let parameter = "dto.\(info.dtoName)"
        return "\(processorMethodName)(\(parameter))"
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
        ConvertFromDTOMacro.self,
        DTOPropertyNameMacro.self,
    ]
}

internal struct ConvertInfo {
    fileprivate let sourceType: TypeAnnotationSyntax
    fileprivate let destinationType: TypeAnnotationSyntax
    fileprivate let convertClosure: ClosureExprSyntax
    fileprivate var debug: String = ""
}

internal struct ParsedVariableInfo {
    fileprivate let accessor: Keyword
    fileprivate let hasConvertType: Bool
    fileprivate let convertInfo: ConvertInfo?
    fileprivate let businessName: String
    fileprivate let dtoName: String
    fileprivate let type: TypeAnnotationSyntax
    fileprivate let debug: String?
    fileprivate let diagnostics: [Diagnostic]
    
    init(accessor: Keyword, hasConvertType: Bool, convertInfo: ConvertInfo?, businessName: String, dtoName:String? = nil, type: TypeAnnotationSyntax, debug: String?, diagnostics: [Diagnostic] = []) {
        self.accessor = accessor
        self.hasConvertType = hasConvertType
        self.convertInfo = convertInfo
        self.businessName = businessName
        self.dtoName = dtoName ?? businessName
        self.type = type
        self.debug = debug
        self.diagnostics = diagnostics
    }
}

internal enum MacroUtils {
    
    internal static func getDTOAccessor(declaration: DeclGroupSyntax)-> Keyword {
        guard let attribute = SU.get(attributeNamed: MacroName.DecodableFromDTO, in: declaration.as(StructDeclSyntax.self)),
              let labels = attribute.arguments?.as(LabeledExprListSyntax.self),
              let accessor = SU.getParameterValue(in: labels, for: "access")?.as(MemberAccessExprSyntax.self)?.declName.baseName.text
        else { return DefaultAccessor}
        switch accessor {
            case "public" :
                return .public
            case "internal" :
                return .internal
            case "fileprivate" :
                return .fileprivate
            default :
                return DefaultAccessor
        }
    }
    
    internal static func getConvertInfo(from varDecl: VariableDeclSyntax) -> ConvertInfo?{
        guard let convertAttribute = SU.get(attributeNamed: MacroName.ConvertDTOType, in: varDecl)
        else {return nil}
        
        return getConvertInfo(from: convertAttribute)
    }
    
    internal static func getConvertDTOInfo(from varType: TypeAnnotationSyntax) -> ConvertInfo? {
       
        var rootType = varType.type
        var isOptional = false
        if let optionalType = varType.type.as(OptionalTypeSyntax.self) {
            rootType = optionalType.wrappedType
            isOptional = true
        }
        
        let dtoType = "\(rootType).DTO\( isOptional ? "?" : "")"
        let sourceType = TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: dtoType))
        
        return ConvertInfo(
            sourceType: sourceType,
            destinationType: varType,
            convertClosure: ClosureExprSyntax(
                signature: ClosureSignatureSyntax(
                    parameterClause: SC.createClosureCallParamters(withName: DTOTokenName.dto),
                    returnClause: ReturnClauseSyntax(varType)
                ),
                statements: CodeBlockItemListSyntax(stringLiteral: isOptional ? "\(DTOTokenName.dto).map{\(rootType)(from: $0)}" : "\(rootType)(from: \(DTOTokenName.dto)")
            ),
            debug: "dto: \(dtoType) optional : \(isOptional)"
        )
    }
    
    internal static func getConvertInfo(from attribute: AttributeSyntax) -> ConvertInfo?{
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
              let sourceType = getConvertSourceType(in: arguments),
              let destinationType =  getConvertDestinationType(in: arguments),
              let conversionClosure = getConvertConversionClosure(in: arguments) else {return nil}
        
        return ConvertInfo(sourceType: sourceType, destinationType: destinationType, convertClosure: conversionClosure)
    }
    
    internal static func getDTOPropertyName(from varDecl: VariableDeclSyntax) -> String? {
        guard let convertAttribute = SU.get(attributeNamed: MacroName.DTOPropertyName, in: varDecl),
              let arguments = convertAttribute.arguments?.as(LabeledExprListSyntax.self),
              let expr = SU.getParameterValue(in: arguments, for: "name"),
              let DTONameLiteral = expr.as(StringLiteralExprSyntax.self),
              let DTOName = DTONameLiteral.segments.first?.as(StringSegmentSyntax.self)?.content
        else {return nil}
        return DTOName.text
    }
    
    internal static func getConvertSourceType(in attribute: AttributeSyntax) -> TypeAnnotationSyntax? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
              let value = SU.getParameterValue(in: arguments, for: "from") else { return nil }
        return SU.convert(exprSyntax: value)
    }
    
    private static func getConvertSourceType(in arguments: LabeledExprListSyntax) -> TypeAnnotationSyntax? {
        guard let value = SU.getParameterValue(in: arguments, for: "from") else { return nil }
        return SU.convert(exprSyntax: value)
    }
    
    internal static func getConvertDestinationType(in attribute: AttributeSyntax) -> TypeAnnotationSyntax? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
              let value = SU.getParameterValue(in: arguments, for: "to") else { return nil }
        return SU.convert(exprSyntax: value)
    }

    internal static func getConvertDestinationTypeOrignialNode(in attribute: AttributeSyntax) -> ExprSyntax? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
              let value = SU.getParameterValue(in: arguments, for: "to") else { return nil }
        return value
    }
    
    private static func getConvertDestinationType(in arguments: LabeledExprListSyntax) -> TypeAnnotationSyntax? {
        guard let value = SU.getParameterValue(in: arguments, for: "to") else { return nil }
        return SU.convert(exprSyntax: value)
    }
    
    internal static func getConvertConversionClosure(in attribute: AttributeSyntax) -> ClosureExprSyntax? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {return nil}
        return SU.getParameterValue(in: arguments, for: "convert")?.as(ClosureExprSyntax.self)
    }
    
    private static func getConvertConversionClosure(in arguments: LabeledExprListSyntax) -> ClosureExprSyntax? {
        return SU.getParameterValue(in: arguments, for: "convert")?.as(ClosureExprSyntax.self)
    }
    
    internal static func getDiagnostics(for variable: VariableDeclSyntax) -> [Diagnostic] {
        var result: [Diagnostic] = []
        
        let convertInfo = MacroUtils.getConvertInfo(from: variable)
        let propertyType = variable.bindings.first?.typeAnnotation?.as(TypeAnnotationSyntax.self)
        
        if !SNC.compare(propertyType , convertInfo?.destinationType) {
            result.append(DiagnosticBuilder.buildTypeError(for: variable))
        }
        
        return result
    }
}

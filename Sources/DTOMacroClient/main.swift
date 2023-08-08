import DTOMacro
import DTOTypes
import Foundation
//let a = 17
//let b = 25
//
//let (result, code) = #stringify(a + b)
//
//print("The value \(result) was produced by the code \"\(code)\"")

public extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        if contains(".") {
            formatter.formatOptions.insert(.withFractionalSeconds)
        }
        return formatter.date(from: self)
    }
}

@DecodableFromDTO
public struct SomeDataM {
    public let name:String
    @ConvertDTOType(from: String, to: Date?, convert: { source in source.toDate() })
    public let date: Date?
    public let age:Int
    public let address: Address
    public let sex:String
}

public struct Address: Codable {
    public let number: Int
    public let street: String
    public let zipcode: Int
    public let city: String
}

public class TransformationType<SourceType, DestinationType> {
    public let sourceType = SourceType.Type.self
    public let destinationType = DestinationType.Type.self
    
    public let transform: (_ source: SourceType) -> DestinationType
    
    init(transformationAction: @escaping (_: SourceType) -> DestinationType) {
        self.transform = transformationAction
    }
}



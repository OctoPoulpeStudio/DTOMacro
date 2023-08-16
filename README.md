
# DTOMacro
A Swift Macro that generate DTOs.

## TL;DR
- provides protocol `DecodableFromDTOProtocol` for DTO to easily encapsulate data
- Provides an extension to decode object from DTO directly with JSONDecoder
- Generate boilerplate code for type conversion through DTOs

## Prerequisites

- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/OctoPoulpeStudio/DTOMacro.git", from: "1.0.0")
]
```

## Usage 
1. **Import DTOMacro**:
 ```swift
import DTOMacro
```
2. Add the attribute `@DecodableFromDTO` to the struct name of your Business data
``` Swift 
@DecodableFromDTO
struct MyData {
	let name: String
	let birthday:Date?
}
```
3. Add one of the conversion attribute  to the properties you want to convert.
3.1. `@ConvertDTOType(from: SourceType, to: BusinessDataType, convert: ConversionClosure)` 
	- SourceType : the type of the data you received
	- BusinessType : the type of the property you want to convert
	- ConversionClosure :  An Explicite Closure to convert SourceType int BusinessType. 
		- [!NOTE] : the body of the closure must be in the attribute since it is copied as a string by SwiftSyntaxt. 
```Swift 
@DecodableFromDTO
struct MyData {
	let name: String
	@ConvertDTOType(from: String, to: Date, convert: {ISO8601DateFormatter().date(from:$0)})
	let birthday:Date?
}
```
3.2. `@ConvertFromDTO `to automatically convert an object that is created from DTO as well

```Swift 
@DecodableFromDTO
struct MyData {
	let name: String
	@ConvertFromDTO
	let myProperty:ATypeUsingTheDecodableFromDTOProtocol
}
```
 Example : 
```Swift 
@DecodableFromDTO
struct MyData {
	let name: String
	@ConvertDTOType(from: String, to: Date, convert: {ISO8601DateFormatter().date(from:$0)})
	let birthday:Date?
}
```

will generate : 

```Swift 
extension MyData: DecodableFromDTOProtocol {
    public struct DTO: Decodable {
        public let name: String
        public let birthdate: String
    }
    private struct DTOConversionProcessor {
        fileprivate static var birthdate: (String) -> Date? = {
            ISO8601DateFormatter().date(from: $0)
        }
    }
    public init(from dto: DTO) {
        self.name = dto.name
        self.birthdate = DTOConversionProcessor.birthdate(dto.birthdate)
    }
}
```
 

## Detailed Explanation

### What is DTO
DTO stand for Data Transfer Object. 
It's a design pattern that allow the business data to be consistante with the need of the application.

### How do you use it?

By creating in intermediary data type in your language (Swift in this case) that represent the data structure as it is received by the app (usually from an API via Json) 

For example you might receive data from the server named "birthdate" that represent a Date but is actually a String.

How do you do the conversion from string to a Date in a seamless action? You might use a special `init(from:Decoder)` initialiser with specific code that you forgot how to write or you can use DTO to convert your data easily with this intermediary object.

This would look like this : 
##### The JSON received : 
```JSON 
{
	birthdate:"2023-07-07T17:06:40.0433333+02:00"
}
```
#####  The Business data
```Swift 
struct MyData {
	let birthday:Date?
}
```

Here you cannot directly convert `String` to `Date?`.

So you can use the DTO design pattern

##### The DTO object

``` Swift
struct MyDataDTO {
	let birthdate: String
}
```
And create a special init in your business data type : 

#####  The transformed Business data
```Swift 
struct MyData {
	let birthday:Date?
	init(from dto: MyDataDTO) {
		self.birthdate = ISO8601DateFormatter().date(from:dto.birthday)
	}
}
```

Now a better way to use DTO is to nest the DTO type into your business data, hence having a uniformed way of writing them that we can embed in a protocol `DecodableFromDTOProtocol`. We can, at the same time, group them in an extension to keep our business data clean  : 
##### The DecodableFromDTOProtocol 
```Swift 
public protocol DecodableFromDTOProtocol {
    associatedtype DTO: Decodable
    init(from dto: DTO) throws
}
```
##### Business data with extension
```Swift
struct MyData {
	let birthday:Date?
}

extension MyData: DecodableFromDTOProtocol {
	public struct DTO {
		let birthday: String
	}
	init(from dto: DTO) {
		self.birthday = ISO8601DateFormatter().date(from:dto.birthday)
	}
}
```

The code we have is easy to read but not really easy to write. As you can see it adds a lot of boilerplate code. We now have a nested struct name DTO that has the same properties as our main struct and we have a new initialiser that does the conversion. 

Which mean that we have 3 places to take care of if any change occurs.

### Using SwiftMacro to reduce boilerplate code

SwiftMacro is a feature of Swift 5.9 that allow us, developper, to create code that generates code at compile time.


So how to use SwiftMacro to rescue us?

The idea is to create an `attached macro` that does all the work the `DecodableFromDTO` . And use other attached macro that doesn't generate any code  as a way to tag property by abusing the macro system to generate our own attribute.

Therefore the `DecodableFromDTO` is mandatory to get any code generation.
and the other attributes `@ConvertDTOType(from: APIType, to: BusinessType, convert: ConversionClosure)` and  `@ConvertFromDTO` just give context to `DecodableFromDTO` but don't generate anything. 

 [!NOTE]  : 
- that by using the macro system we can pass parameters and type check them.
- these macros are also used to detect error in there usage.

##### Macro creation

The `DecodableFromDTO`macro works as follow : 
		

 - Get all the properties of the type it's attached to.
 - Check for any attribute on them.
	 - if any gather the sourceType, destinationType and conversion closure
 - Create an extension to the type it's attached to.
 - Add the conformance to DecodableFromDTOProtocol
 - Add a new type nested into this extension named `DTO`
 - Fill `DTO` with all the properties of the main type.
	 - by default type the properties with the type of the property from the type it's attached to.
	 - if any attribute have been found, type the DTO property with the sourceType
 - Create a private enum to store all the conversion for each property with conversion attributes
 - Fill it with the conversion closures
 - Create an initialiser `init(from dto: DTO)`
 - Fill this initialiser with the main type property assignation from the properties in DTO.
	 - by default use directly the DTO property
	 - if any conversion attribute, assign the result from the conversion closure where the dto property has been passed as parameter


#### Additional notes 
This package embed the `DecodableFromDTOProtocol` protocol
It also embed an extension to JsonDecoder to directly and seamlessly get the business data from a JSON

``` swift
extension JSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: DecodableFromDTOProtocol {
        try T(from: decode(T.DTO.self, from: data))
    }
}
```

[!NOTE] : the protocol and the extension have been created by Luis Recuenco and were taken from his article in [Better Programming](https://betterprogramming.pub/parsing-in-swift-a-dto-based-approach-5edca55eb57a)

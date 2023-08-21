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
import DTOMacrosImpl

// TODO: a way to flatten the path to data : eg data.prop from data.group.prop

// The default paramter is not used since we don't actually get the value of the paramter but a string representation of it.
// when the default is used the string doesn't have any parameter
// the only porpuse for us it to allow the user to not type the access parameter if not needed
// the macro is using the global variable DefaultAccessor

/// This is the main macro attribute.
/// It's mandatory to have any DTO generation.
/// 
/// This macro does the whole code generation, however the DTO generated with only this attribute will be useless since the DTO and your business type will be identical.
///
/// You need to add other attribute to generate changes from the DTO
/// For example you can add a ``DTOProperty(name:)`` attribute above a property where the name from the data received is different from the name you want in your business logic.
///
/// # Usage:
///
/// ### Default
///
/// ```swift
/// @DecodableFromDTO
/// struct MyData {
///        ...
/// }
/// ```
/// ### With access selection
///
/// ```swift
/// @DecodableFromDTO(access: .public)
/// struct MyData {
///        ...
/// }
/// ```
///
/// - Parameters:
///    - access: Change the accessibility of the properties of the DTO type. Can be ommited, for a default value of ``.public``.
///
@attached(extension, conformances: DecodableFromDTOProtocol, names: named(DTO),named(DTOConversionProcessor), named(init(from:)))
public macro DecodableFromDTO(access: DTOAccessibility = .public) = #externalMacro(module: "DTOMacrosImpl", type: "DecodableFromDTOMacro")


/// This attribute indicate to the main macro that your property type from business logic must be converted from another type.
///
/// > The type indication help the type checking of the convert closure.
///
/// # Usage:
/// ```swift
/// ...
///  @ConvertDTOType(from: String, to: Date?, convert: { ISO8601DateFormatter().date(from:$0)})
///  let birthdate: Date?
/// ```
/// > This attribute can be combine with ``DTOProperty(name:)``
///
/// + important: `birhtdate` and `to` must be a strictly identical
///
/// - Parameters:
///   - from: The type you receive, and therefore the type of your DTO property
///   - to: the type of you business logic propety.
///   - convert: A closure that transform the data from the received type to the business type
///
///
@attached(peer)
public macro ConvertDTOType<SourceType, DestinationType>(from:SourceType.Type, to: DestinationType.Type, convert: (SourceType)->DestinationType) = #externalMacro(module: "DTOMacrosImpl", type: "ConvertDTOMacro")

/// This attribute is a shortcute to convert a property from a DTO property.
/// You can use it instead of ``ConvertDTOType(from:to:convert:)``
///
/// # Usage:
/// add it to the top of the porperty you want to convert from a DTO :
///
/// ```swift 
/// @ConvertFromDTO
/// public let myProprety: ABusinessType?
/// ```
///
/// > This attribute is equivalent to :
/// ```@ConvertDTOType(from: BusinessType.DTO, to: BusinessType?, convert: { BusinessType.init(from: $0) })```
///
/// > This attribute can be combine with ``DTOProperty(name:)``
@attached(peer)
public macro ConvertFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "ConvertFromDTOMacro")

/// This attribute allow you to change the name of the property insode the DTO type to conform to what you receive.
///
/// # Usage:
/// ```swift
/// @DTOProperty(name: "a_name")
/// let name: String
/// ```
///  will generate :
///  ```swift
///  public struct DTO: Decodable {
///      public let a_name: String
///      ...
///  }
///  ```
///
/// > This attribute can be combite with ``DTOProperty(name:)`` or ``ConvertFromDTO``
///
/// - Parameters:
///   - name: The name of the property inside the DTO
@attached(peer)
public macro DTOProperty(name: String) = #externalMacro(module: "DTOMacrosImpl", type: "DTOPropertyNameMacro")

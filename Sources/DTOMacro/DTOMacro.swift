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
@attached(extension, conformances: DecodableFromDTOProtocol, names: named(DTO),named(DTOConversionProcessor), named(init(from:)))
public macro DecodableFromDTO(access: DTOAccessibility = .internal) = #externalMacro(module: "DTOMacrosImpl", type: "DecodableFromDTOMacro")

@attached(peer)
public macro ConvertDTOType<SourceType, DestinationType>(from:SourceType.Type, to: DestinationType.Type, convert: (SourceType)->DestinationType) = #externalMacro(module: "DTOMacrosImpl", type: "ConvertDTOMacro")

@attached(peer)
public macro ConvertFromDTO() = #externalMacro(module: "DTOMacrosImpl", type: "ConvertFromDTOMacro")

@attached(peer)
public macro DTOProperty(name: String) = #externalMacro(module: "DTOMacrosImpl", type: "DTOPropertyNameMacro")

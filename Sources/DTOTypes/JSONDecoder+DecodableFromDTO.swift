//
//  JSONDecoder+DecodableFromDTO.swift
//
//
//  Created by la pieuvre on 15/08/2023.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: DecodableFromDTOProtocol {
        try T(from: decode(T.DTO.self, from: data))
    }
}

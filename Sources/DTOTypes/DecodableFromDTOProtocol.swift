//
//  DecodableFromDTOProtocol.swift
//  
//
//  Created by la pieuvre on 06/08/2023.
//

public protocol DecodableFromDTOProtocol {
    associatedtype DTO: Decodable
    init(from dto: DTO) throws
}

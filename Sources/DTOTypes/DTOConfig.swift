//
//  DTOConfig.swift
//  
//
//  Created by la pieuvre on 06/08/2023.
//

public struct DTOConfig {
    private var rules: [DTORuleProtocol] = []
    
    public init() {}
    public mutating func add(rule: DTORuleProtocol) {
        rules.append(rule)
    }
    
    public func getRule(for sourceType:String) -> DTORuleProtocol? {
        rules.first { rule in
            rule.sourceType == sourceType
        }
    }
}

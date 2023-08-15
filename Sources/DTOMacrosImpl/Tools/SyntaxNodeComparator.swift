//
//  SyntaxNodeComparator.swift
//  
//
//  Created by la pieuvre on 13/08/2023.
//

import SwiftSyntax

internal typealias SNC = SyntaxNodeComparator
internal enum SyntaxNodeComparator {
    internal static func compare(_ lhs: SyntaxProtocol?, _ rhs: SyntaxProtocol?) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

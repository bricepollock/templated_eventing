//
//  String+camel.swift
//  EventTemplatingEngine
//
//  Created by Brice Pollock on 4/12/22.
//

import Foundation

extension String {
    func camelCased(with separator: Character) -> String {
        return self.lowercased()
            .split(separator: separator)
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }
}

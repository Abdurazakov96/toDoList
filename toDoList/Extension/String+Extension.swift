//
//  File.swift
//  toDoList
//
//  Created by Магомед Абдуразаков on 28/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import Foundation

extension String {
    var capitalizedWithSpaces: String {
        let withSpaces = reduce("") {
            result, character in character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        return withSpaces.capitalized
    }
}

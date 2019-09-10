//
//  Date.swift
//  toDoList
//
//  Created by Магомед Абдуразаков on 28/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
}

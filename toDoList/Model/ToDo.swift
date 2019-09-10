//
//  ToDo.swift
//  toDoList
//
//  Created by Магомед Абдуразаков on 27/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

@objcMembers class ToDo: NSObject {
    var title: String
    var isComplete:Bool
    var dueDate: Date
    var note: String?
    var image: UIImage?
    
    init(
        title: String = "",
        isComplete:Bool = false,
        dueDate: Date = Date(),
        note: String? = nil,
        image: UIImage? = nil )
    {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.note = note
        self.image = image
    }
    
    var capitalezedKeys: [String] {
        return keys.map{$0.capitalizedWithSpaces}
    }
    var keys: [String] {
        return Mirror(reflecting: self).children.compactMap{$0.label}
    }
    
    var values: [Any?] {
        return Mirror(reflecting: self).children.map{$0.value}
    }
    
    override func copy() -> Any {
        let NewToDo = ToDo(
            title: title,
            isComplete: isComplete,
            dueDate: dueDate,
            note: note,
            image: image?.copy() as? UIImage)
    
    return NewToDo
    }
}

//
//  TaskObject.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 16.06.2021.
//

import Foundation
import RealmSwift

class TaskObject: Object {
    @objc dynamic var taskText = ""
    @objc dynamic var isChecked: Bool = false
}

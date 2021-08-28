//
//  CoreDataManager.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 03.07.2021.
//

import UIKit
import CoreData

class CoreDataManager {
    var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
}

//
//  TaskEntity.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 17.06.2021.
//

import Foundation
import CoreData

class TaskEntity: NSManagedObject {
    
    static func createObjects(task: String, isChecked: Bool = false, context: NSManagedObjectContext) -> TaskEntity {
        let taskEntity = TaskEntity(context: context)
        taskEntity.task = task
        taskEntity.isChecked = isChecked
        
        return taskEntity
    }
    
    
    class func getAll(context: NSManagedObjectContext) throws -> [TaskEntity] {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                return try context.fetch(request)
            } catch {
                throw error
            }
        }
}

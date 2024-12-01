//
//  TaskItemsStorage.swift
//  ToDoApp
//
//  Created by Irina Deeva on 01/12/24.
//

import UIKit
import CoreData

final class TaskItemsStorage {
  private let context: NSManagedObjectContext

  convenience init() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          self.init()
          return
      }

      let context = appDelegate.context
      self.init(context: context)
  }

  init(context: NSManagedObjectContext) {
      self.context = context
  }

//  func fetchAll() -> [TaskItem] {
//    let request: NSFetchRequest<TaskItem> = TaskItem.self.fetc
//    return context.fetch(request)
//  }

//  func deleteTaskItem(_ taskItem: TaskItem) {
//    context.dealloc(taskItem)
//  }

  func addTaskItem(_ taskItem: TaskItem) {
    let task = ToDoItem(context: context)

//    task.id = taskItem.id
    task.name = taskItem.todo
    task.itemDescription = taskItem.description
    task.date = taskItem.createdAt
    task.completed = taskItem.completed

  }

}

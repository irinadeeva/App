//
//  TaskItemsStorage.swift
//  ToDoApp
//
//  Created by Irina Deeva on 01/12/24.
//

import UIKit
import CoreData

enum TaskStoreError: Error, ErrorWithMessage {
  case decodingErrorInvalidId
  case decodingErrorInvalidName
  case entityNotFound
  case saveFailed
  case fetchFailed(Error)

  var message: String {
          switch self {
          case .decodingErrorInvalidId:
              return "Error decoding task: invalid ID."
          case .decodingErrorInvalidName:
              return "Error decoding task: invalid name."
          case .entityNotFound:
              return "The requested task was not found."
          case .saveFailed:
              return "Failed to save changes. Please try again."
          case .fetchFailed(let fetchError):
              return "Failed to fetch tasks: \(fetchError.localizedDescription)"
          }
      }
}

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

  func fetchAll() -> [TaskItem] {
    let request = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")

    do {
      let todoItems = try context.fetch(request)
      let taskItems = try todoItems.map { try self.taskItem(from: $0) }
      print("Fetched task items: \(taskItems)")
      return taskItems
    } catch {
      print("Error fetching task items: \(error)")
      return []
    }
  }

  func fetchAll(completion: @escaping (Result<[TaskItem], TaskStoreError>) -> Void) {
    let request = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")

    do {
      let todoItems = try context.fetch(request)
      let taskItems = try todoItems.map { try self.taskItem(from: $0) }
      completion(.success(taskItems))
    } catch {
      completion(.failure(.fetchFailed(error)))
    }
  }

  func deleteTaskItem(_ taskItem: TaskItem) throws {
    guard let todoItem = try predicateFetchById(taskItem.id) else {
      //TODO: error handler
      return
    }

    context.delete(todoItem)

    try? context.save()
  }

  func deleteTaskItem(_ taskItem: TaskItem, completion: @escaping (Result<UUID, TaskStoreError>) -> Void) {
    do {
      guard let todoItem = try predicateFetchById(taskItem.id) else {
        completion(.failure(.entityNotFound))
        return
      }

      context.delete(todoItem)

      do {
        try context.save()
        completion(.success(taskItem.id))
      } catch {
        context.rollback()
        completion(.failure(.saveFailed))
      }
    } catch {
      completion(.failure(.fetchFailed(error)))
    }
  }

  func updateTaskItem(_ taskItem: TaskItem, completion: @escaping (Result<TaskItem, TaskStoreError>) -> Void) {
      do {
          guard let todoItem = try predicateFetchById(taskItem.id) else {
              completion(.failure(.entityNotFound))
              return
          }

          todoItem.id = taskItem.id
          todoItem.name = taskItem.todo
          todoItem.itemDescription = taskItem.description
          todoItem.date = taskItem.createdAt
          todoItem.completed = taskItem.completed

          do {
              try context.save()
              completion(.success(taskItem))
          } catch {
              context.rollback()
              completion(.failure(.saveFailed))
          }
      } catch {
          completion(.failure(.fetchFailed(error)))
      }
  }

  func updateTaskItem(_ taskItem: TaskItem) throws {
    guard let todoItem = try predicateFetchById(taskItem.id) else {
      //TODO: error handler
      return
    }

    todoItem.id = taskItem.id
    todoItem.name = taskItem.todo
    todoItem.itemDescription = taskItem.description
    todoItem.date = taskItem.createdAt
    todoItem.completed = taskItem.completed

    do {
      try context.save()
    } catch {
      context.rollback()
    }
  }

  func addTaskItem(_ taskItem: TaskItem) {
    let todoItem = ToDoItem(context: context)

    todoItem.id = taskItem.id
    todoItem.name = taskItem.todo
    todoItem.itemDescription = taskItem.description
    todoItem.date = taskItem.createdAt
    todoItem.completed = taskItem.completed

    do {
      try context.save()
    } catch {
      context.rollback()
    }
  }

  func addTaskItem(_ taskItem: TaskItem, completion: @escaping (Result<TaskItem, TaskStoreError>) -> Void) {
    print("Saving task item: \(taskItem)")
      let todoItem = ToDoItem(context: context)

      todoItem.id = taskItem.id
      todoItem.name = taskItem.todo
      todoItem.itemDescription = taskItem.description
      todoItem.date = taskItem.createdAt
      todoItem.completed = taskItem.completed


      do {
          try context.save()
          completion(.success(taskItem))
      } catch {
          context.rollback()
          completion(.failure(.saveFailed))
      }
  }

  private func taskItem(from todoItem: ToDoItem) throws -> TaskItem {
    guard let id = todoItem.id else {
      throw TaskStoreError.decodingErrorInvalidId
    }
    guard let name = todoItem.name else {
      throw TaskStoreError.decodingErrorInvalidName
    }

    let description = todoItem.itemDescription
    let date = todoItem.date
    let completed = todoItem.completed

    return TaskItem(id: id, todo: name, completed: completed, description: description, createdAt: date)
  }

  private func predicateFetchById(_ taskId: UUID) throws -> ToDoItem? {
    let request = ToDoItem.fetchRequest()
    request.returnsObjectsAsFaults = false

    request.predicate = NSPredicate(format: "id == %@", taskId.uuidString)
    request.fetchLimit = 1

    do {
      let results = try context.fetch(request)
      return results.first
    } catch {
      throw TaskStoreError.fetchFailed(error)
    }
  }
}

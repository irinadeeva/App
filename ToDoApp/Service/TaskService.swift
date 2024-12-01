//
//  File.swift
//  ToDoApp
//
//  Created by Irina Deeva on 30/11/24.
//

import Foundation

typealias TaskCompletion = (Result<[TaskItem], Error>) -> Void

protocol TaskServiceProtocol {
  func loadTaskItems(completion: @escaping TaskCompletion)
}

final class TaskService {
  static let shared = TaskService()
  private let networkClient = DefaultNetworkClient()
  private let storage = TaskItemsStorage()

  private init() {}
}

extension TaskService: TaskServiceProtocol {
  func loadTaskItems(completion: @escaping TaskCompletion) {
//
//    //TODO: do a completion with error
//    let taskItems = storage.fetchAll()

    storage.fetchAll { [self] result in
        switch result {
        case .success(let tasks):
            print("Fetched \(tasks.count) tasks.")
          if tasks.isEmpty {
            let request = TaskItemsRequest()

            networkClient.send(request: request, type: TodosResponse.self) { [weak self] result in
              switch result {
              case .success(let data):
                let taskItems = data.todos.toTaskItems()

                taskItems.forEach { taskItem in
                  self?.storage.addTaskItem(taskItem)
                }

                print(data)
                completion(.success(taskItems))
              case .failure(let error):
                completion(.failure(error))
              }
            }
          } else {
            completion(.success(tasks))
          }
        case .failure(let error):
            print("Failed to fetch tasks: \(error.localizedDescription)")
          completion(.failure(error))
        }
    }
  }
}

private extension TaskService {
}

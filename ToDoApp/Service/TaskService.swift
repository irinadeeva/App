//
//  File.swift
//  ToDoApp
//
//  Created by Irina Deeva on 30/11/24.
//

import Foundation

typealias TaskCompletion = (Result<[TaskItem], Error>) -> Void

protocol TaskServiceProtocol {
  func loadPhoto(completion: @escaping TaskCompletion)
}

final class TaskService {
  static let shared = TaskService()

  private let networkClient = DefaultNetworkClient()
  //  private let storage = TaskStorage()

  private init() {}
}

extension TaskService: TaskServiceProtocol {
  func loadPhoto(completion: @escaping TaskCompletion) {
    let request = TaskItemsRequest()

    networkClient.send(request: request, type: TodosResponse.self) { [weak self] result in
      switch result {
      case .success(let data):
        // self?.storage.savePhoto(validPhoto)a
        let taskItems = data.todos
        print(data)
        completion(.success(taskItems))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

struct TaskItemsRequest: NetworkRequest {
  var endpoint = "\(RequestConstants.baseURL)"

  var httpMethod: HttpMethod { .get }
}


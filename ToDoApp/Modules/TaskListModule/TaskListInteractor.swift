//
//  TaskListInteractor.swift
//
//  Created by Irina Deeva on 29/11/24
//

protocol TaskListInteractorInput: AnyObject {
  func fetchTasks()
  func updateTaskItem(_ taskItem: TaskItem)
}

protocol TaskListInteractorOutput: AnyObject {
  func didFetchTasks(_ tasks: [TaskItem])
  func didFetchTask(_ task: TaskItem)
  func didFailToFetchTasks(with error: Error)
}

final class TaskListInteractor: TaskListInteractorInput {
  weak var output: TaskListInteractorOutput?

  func fetchTasks() {
    TaskService.shared.loadTaskItems { [weak self] result in
      switch result {
        case .success(let tasks):
        self?.output?.didFetchTasks(tasks)
      case .failure(let error):
        self?.output?.didFailToFetchTasks(with: error)
      }
    }
  }

  func updateTaskItem(_ taskItem: TaskItem) {
    TaskService.shared.updateTaskItem(taskItem) { [weak self] result in
      switch result {
        case .success:
        self?.output?.didFetchTask(taskItem)
      case .failure(let error):
        self?.output?.didFailToFetchTasks(with: error)
      }
    }
  }
}

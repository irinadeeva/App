//
//  TaskDetailInteractor.swift
//
//  Created by Irina Deeva on 30/11/24
//

protocol TaskDetailInteractorInput: AnyObject {
  func updateTaskItem(_ taskItem: TaskItem)
  func addNewTask(_ taskItem: TaskItem)
}

protocol TaskDetailInteractorOutput: AnyObject {
  func didFetchTask(_ task: TaskItem)
  func didFailToFetchTasks(with error: Error)
}

final class TaskDetailInteractor: TaskDetailInteractorInput {
  weak var output: TaskDetailInteractorOutput?

  func updateTaskItem(_ taskItem: TaskItem) {
    TaskService.shared.updateTaskItem(taskItem) { [weak self] result in
      switch result {
        case .success(let task):
        self?.output?.didFetchTask(task)
      case .failure(let error):
        self?.output?.didFailToFetchTasks(with: error)
      }
    }
  }

  func addNewTask(_ taskItem: TaskItem) {
    TaskService.shared.addTaskItem(taskItem) { [weak self] result in
      switch result {
      case .success(let task):
        self?.output?.didFetchTask(task)
      case .failure(let error):
        self?.output?.didFailToFetchTasks(with: error)
      }
    }
  }
}

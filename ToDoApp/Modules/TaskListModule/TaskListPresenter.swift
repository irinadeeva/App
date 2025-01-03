//
//  TaskListPresenter.swift
//
//  Created by Irina Deeva on 29/11/24
//

import Foundation

enum TaskListState {
  case initial, loading, data([TaskItem]), update(TaskItem), delete(TaskItem), failed(Error)
}

protocol TaskListPresenterProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear()
  func addNewTask()
  func didSelectTask(_ task: TaskItem)
  func didTaskCompleted(_ task: TaskItem)
  func didTaskDeleted(_ task: TaskItem)
  func didTapShareCell(_ task: TaskItem)
}

final class TaskListPresenter {
  weak var view: TaskListViewProtocol?
  var router: TaskListRouterProtocol?
  var interactor: TaskListInteractorInput?

  private var tasks: [TaskItem] = []
  private var state: TaskListState = .initial {
    didSet {
      stateDidChanged()
    }
  }

  private func stateDidChanged() {
    switch state {
    case .initial:
      assertionFailure("can't move to initial state")
    case .loading:
      view?.showLoadingAndBlockUI()
      interactor?.fetchTasks()
    case .data(let tasks):
      self.tasks = tasks
      view?.showTasks(tasks)
      view?.hideLoadingAndUnblockUI()
    case .failed(let error):
      let errorModel = makeErrorModel(error)
      view?.hideLoadingAndUnblockUI()
      view?.showError(errorModel)
    case .update(let taskItem):
      view?.showLoadingAndBlockUI()
      interactor?.updateTaskItem(taskItem)
    case .delete(let taskItem):
      view?.showLoadingAndBlockUI()
      interactor?.deleteTaskItem(taskItem)
    }
  }

  private func makeErrorModel(_ error: Error) -> ErrorModel {
    let message: String

    if let errorWithMessage = error as? ErrorWithMessage {
      message = errorWithMessage.message
    } else {
      message = "An unknown error occurred. Please try again later."
    }

    let actionText = "Repeat"
    return ErrorModel(message: message,
                      actionText: actionText) { [weak self] in
      self?.state = .loading
    }
  }
}

extension TaskListPresenter: TaskListInteractorOutput {
  func didFetchId(_ taskId: UUID) {
    tasks.removeAll { $0.id == taskId }
    
    state = .data(tasks)
  }
  
  func didFetchTask(_ task: TaskItem) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks[index] = task
    }

    state = .data(tasks)
  }
  
  func didFetchTasks(_ tasks: [TaskItem]) {
    state = .data(tasks)
  }

  func didFailToFetchTasks(with error: Error) {
    state = .failed(error)
  }
}

extension TaskListPresenter: TaskListPresenterProtocol {
  func viewDidLoad() {
    state = .loading
  }

  func viewWillAppear(){
    state = .loading
  }

  func didSelectTask(_ task: TaskItem) {
    router?.navigateToTaskDetail(with: task)
  }

  func didTaskCompleted(_ task: TaskItem) {
    var updateTask = task
    updateTask.completed.toggle()

    state = .update(updateTask)
  }

  func didTaskDeleted(_ task: TaskItem) {
    state = .delete(task)
  }

  func addNewTask() {
    router?.navigateToAddNewTask()
  }

  func didTapShareCell(_ task: TaskItem) {
    router?.shareTask(task)
  }
}

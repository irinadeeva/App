//
//  TaskDetailPresenter.swift
//
//  Created by Irina Deeva on 30/11/24
//

import Foundation

enum TaskDetailState {
  case initial, loading, data(TaskItem), update(TaskItem), create(TaskItem), failed(Error)
}

protocol TaskDetailPresenterProtocol: AnyObject {
  func viewDidLoad()
  func viewWillDisappear(_ task: TaskItem)
}

final class TaskDetailPresenter {
  weak var view: TaskDetailViewProtocol?
  var router: TaskDetailRouterProtocol?
  var interactor: TaskDetailInteractorInput?

  private var task: TaskItem?
  private var isNewTask = false
  private var state: TaskDetailState = .initial {
    didSet {
      stateDidChanged()
    }
  }

  init(task: TaskItem? = nil) {
    self.task = task
  }

  private func stateDidChanged() {
    switch state {
    case .initial:
      assertionFailure("can't move to initial state")
    case .loading:
      view?.showLoadingAndBlockUI()
//      interactor?.fetchTasks()
    case .data(let task):
      self.task = task
      view?.showTask(task)
      view?.hideLoadingAndUnblockUI()
    case .failed(let error):
      let errorModel = makeErrorModel(error)
      view?.hideLoadingAndUnblockUI()
      view?.showError(errorModel)
    case .update(let taskItem):
      view?.showLoadingAndBlockUI()
      interactor?.updateTaskItem(taskItem)
    case .create(let taskItem):
      view?.showLoadingAndBlockUI()
      interactor?.addNewTask(taskItem)
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

extension TaskDetailPresenter: TaskDetailInteractorOutput {
  func didFetchTask(_ task: TaskItem) {
    self.task = task

    state = .data(task)
  }
  
  func didFailToFetchTasks(with error: any Error) {
    state = .failed(error)
  }
}

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
  func viewDidLoad() {
    if let task {
      state = .data(task)
    } else {
      task = TaskItem(id: UUID(), todo: "New Task", completed: false, description: "", createdAt: Date())
      isNewTask = true
       guard let task else { return }
      state = .data(task)
    }
  }

  func viewWillDisappear(_ task: TaskItem) {
    if isNewTask {
      state = .create(task)
    } else {
      state = .update(task)
    }
  }
}


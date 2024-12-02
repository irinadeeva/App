//
//  TaskDetailPresenter.swift
//
//  Created by Irina Deeva on 30/11/24
//

import Foundation

enum TaskDetailState {
  case initial, loading, data(TaskItem), update(TaskItem), delete(TaskItem), failed(Error)
}

protocol TaskDetailPresenterProtocol: AnyObject {
  func viewDidLoad()
}

final class TaskDetailPresenter {
  weak var view: TaskDetailViewProtocol?
  var router: TaskDetailRouterProtocol?
  var interactor: TaskDetailInteractorInput?

  private var task: TaskItem
  private var state: TaskDetailState = .initial {
    didSet {
      stateDidChanged()
    }
  }

  init(task: TaskItem) {
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
//      interactor?.updateTaskItem(taskItem)
    case .delete(let taskItem):
      view?.showLoadingAndBlockUI()
//      interactor?.deleteTaskItem(taskItem)
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
  
}

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
  func viewDidLoad() {
    state = .data(task)
  }
}


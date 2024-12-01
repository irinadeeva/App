//
//  TaskListPresenter.swift
//
//  Created by Irina Deeva on 29/11/24
//

enum TaskListState {
  case initial, loading, data([TaskItem]),
       //       update,
       failed(Error)
}

protocol TaskListPresenterProtocol: AnyObject {
  func viewDidLoad()
  func didSelectTask(_ task: TaskItem)
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
      //    case .update:
      //
    }
  }

  private func makeErrorModel(_ error: Error) -> ErrorModel {
    let message: String

    switch error {
    case let networkError as NetworkClientError:
      switch networkError {
      case .httpStatusCode(let code):
        message = "Network error: HTTP status \(code)"
      case .urlRequestError(let urlError):
        message = "Request error: \(urlError.localizedDescription)"
      case .urlSessionError:
        message = "Connection error: please check your internet"
      case .parsingError:
        message = "Data parsing error: please try again"
      }
    default:
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
  func didFetchTasks(_ tasks: [TaskItem]) {
    state = .data(tasks)
  }

  func didFailToFetchTasks(with error: Error) {
    state = .failed(error)
  }
}

extension TaskListPresenter: TaskListPresenterProtocol {
  func didSelectTask(_ task: TaskItem) {
    router?.navigateToTaskDetail(with: task)
  }

  func viewDidLoad() {
    state = .loading
  }
}

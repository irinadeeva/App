//
//  TaskDetailPresenter.swift
//
//  Created by Irina Deeva on 30/11/24
//

protocol TaskDetailPresenterProtocol: AnyObject {
}

final class TaskDetailPresenter {
  weak var view: TaskDetailViewProtocol?
  var router: TaskDetailRouterProtocol?
  var interactor: TaskDetailInteractorInput?
}

extension TaskDetailPresenter: TaskDetailInteractorOutput {
  
}

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
}


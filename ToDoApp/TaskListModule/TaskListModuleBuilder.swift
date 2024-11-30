//
//  TaskListModuleBuilder.swift
//
//  Created by Irina Deeva on 29/11/24
//

import UIKit

final class TaskListModuleBuilder {
  static func build() -> TaskListViewController {
    let view = TaskListViewController()
    let interactor = TaskListInteractor()
    let presenter = TaskListPresenter()
    let router = TaskListRouter()

    view.presenter = presenter
    presenter.view  = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.output = presenter
    router.viewController = view
    return view
  }
}

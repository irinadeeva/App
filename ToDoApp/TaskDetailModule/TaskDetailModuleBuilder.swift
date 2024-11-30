//
//  TaskDetailModuleBuilder.swift
//
//  Created by Irina Deeva on 30/11/24
//

import UIKit

final class TaskDetailModuleBuilder {
  static func build(for task: Task) -> TaskDetailViewController {
    let view = TaskDetailViewController(task: task)
    let interactor = TaskDetailInteractor()
    let presenter = TaskDetailPresenter()
    let router = TaskDetailRouter()
    
    view.presenter = presenter
    presenter.view  = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.output = presenter
    router.viewController = view
    return view
  }
}

//
//  TaskListRouter.swift
//
//  Created by Irina Deeva on 29/11/24
//

import UIKit

protocol TaskListRouterProtocol {
  func navigateToTaskDetail(with task: TaskItem)
  func navigateToAddNewTask()
}

final class TaskListRouter: TaskListRouterProtocol {
  weak var viewController: TaskListViewController?
  
  func navigateToTaskDetail(with task: TaskItem) {
    let detailsViewController = TaskDetailModuleBuilder.build(for: task)
    viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
  }

  func navigateToAddNewTask() {
    let detailsViewController = TaskDetailModuleBuilder.build()
    viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
  }

}

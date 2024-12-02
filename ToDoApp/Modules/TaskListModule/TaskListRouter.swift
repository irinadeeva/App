//
//  TaskListRouter.swift
//
//  Created by Irina Deeva on 29/11/24
//

import UIKit

protocol TaskListRouterProtocol {
  func navigateToTaskDetail(with task: TaskItem)
  func navigateToAddNewTask()
  func shareTask(_ task: TaskItem)
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

  func shareTask(_ task: TaskItem) {
    let shareText = task.todo
    let shareDescription = task.description ?? ""
    let shareItems: [Any] = ["Check out this task:", shareText, shareDescription]

    let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)

    viewController?.present(activityVC, animated: true, completion: nil)
  }

}

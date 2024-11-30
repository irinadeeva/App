////
////
////  Interector.swift
////  ToDo
////
////  Created by Irina Deeva on 28/11/24.
////
//
//import UIKit
//
//// Object
//// Entry point
//
////protocol AnyRouter {
////  static func start() -> AnyRouter
////}
////
////class UserRouter: AnyRouter {
////  static func start() -> AnyRouter {
////    let router = UserRouter ()
////    // Assign VIP
////    return router
////  }
////}
//
//protocol TaskListRouterInput: AnyObject {
//    func navigateToTaskDetail(with task: Task)
//}
//
//final class TaskListRouter: TaskListRouterInput {
//    weak var viewController: UIViewController?
//
//    func navigateToTaskDetail(with task: Task) {
//        // Упрощённая передача данных через инициализатор TaskDetailViewController.
//        let detailView = TaskDetailViewController(task: task)
//        viewController?.navigationController?.pushViewController(detailView, animated: true)
//    }
//}
//

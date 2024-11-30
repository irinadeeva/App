////
////  Presenter.swift
////  ToDo
////
////  Created by Irina Deeva on 28/11/24.
////
//
//// Object
////protocol
////ref to interactor, router, view
//
//import Foundation
//
////protocol AnyPresenter {
////  var router: AnyRouter? { get set }
////  var interactor: AnyInteractor? { get set }
////  var view: AnyView? { get set }
////
////  func interactorDidFetchUsers(with result: Result<[User], Error>)
////}
////
////class UserPresenter: AnyPresenter {
////  var router: (any AnyRouter)?
////  
////  var interactor: (any AnyInteractor)?
////  
////  var view: (any AnyView)?
////  
////  func interactorDidFetchUsers(with result: Result<[User], any Error>) {
////    
////  }
////  
////}
//
//protocol TaskListViewOutput: AnyObject {
//    func viewDidLoad()
//    func didSelectTask(_ task: Task)
//}
//
//final class TaskListPresenter: TaskListViewOutput, TaskListInteractorOutput {
//    weak var view: TaskListViewInput?
//    var interactor: TaskListInteractorInput?
//    var router: TaskListRouterInput?
//
//    private var tasks: [Task] = []
//
//    func viewDidLoad() {
//        interactor?.fetchTasks()
//    }
//
//    func didFetchTasks(_ tasks: [Task]) {
//        self.tasks = tasks
//        view?.displayTasks(tasks)
//    }
//
//    func didSelectTask(_ task: Task) {
//        router?.navigateToTaskDetail(with: task)
//    }
//}

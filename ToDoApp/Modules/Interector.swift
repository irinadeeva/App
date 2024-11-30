////
////  Interector.swift
////  ToDo
////
////  Created by Irina Deeva on 28/11/24.
////
//
//import Foundation
//
////protocol AnyInteractor {
////  var presenter: AnyPresenter? { get set }
////  func getUsers()
////}
////
////class UserInteractor: AnyInteractor {
////  var presenter: (any AnyPresenter)?
////  
////  func getUsers() {
////  }
////}
//
//protocol TaskListInteractorInput: AnyObject {
//    func fetchTasks()
//}
//
//protocol TaskListInteractorOutput: AnyObject {
//    func didFetchTasks(_ tasks: [Task])
//}
//
//final class TaskListInteractor: TaskListInteractorInput {
//    weak var output: TaskListInteractorOutput?
//
//    func fetchTasks() {
//        // Загружаем данные. Здесь можно подключить API вместо симуляции.
//        let tasks = [
//            Task(id: 1, todo: "Do something nice for someone you care about", completed: false, userId: 152),
//            Task(id: 2, todo: "Memorize a poem", completed: true, userId: 13),
//            Task(id: 3, todo: "Watch a classic movie", completed: true, userId: 68)
//        ]
//        output?.didFetchTasks(tasks)
//    }
//}

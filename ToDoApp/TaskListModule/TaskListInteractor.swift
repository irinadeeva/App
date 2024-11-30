//
//  TaskListInteractor.swift
//
//  Created by Irina Deeva on 29/11/24
//

protocol TaskListInteractorInput: AnyObject {
  func fetchTasks()
}

protocol TaskListInteractorOutput: AnyObject {
  func didFetchTasks(_ tasks: [Task])
  func didFailToFetchTasks(with error: Error)
}

final class TaskListInteractor: TaskListInteractorInput {
  weak var output: TaskListInteractorOutput?

  func fetchTasks() {
    // Загружаем данные. Здесь можно подключить API вместо симуляции.
    let tasks = [
      Task(id: 1, todo: "Do something nice for someone you care about", completed: false, userId: 152),
      Task(id: 2, todo: "Memorize a poem", completed: true, userId: 13),
      Task(id: 3, todo: "Watch a classic movie", completed: true, userId: 68)
    ]
    output?.didFetchTasks(tasks)
  }
}

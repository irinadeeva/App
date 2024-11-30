//
//  TaskListInteractor.swift
//
//  Created by Irina Deeva on 29/11/24
//

protocol TaskListInteractorInput: AnyObject {
  func fetchTasks()
}

protocol TaskListInteractorOutput: AnyObject {
  func didFetchTasks(_ tasks: [TaskItem])
  func didFailToFetchTasks(with error: Error)
}

final class TaskListInteractor: TaskListInteractorInput {
  weak var output: TaskListInteractorOutput?

  func fetchTasks() {
    // Загружаем данные. Здесь можно подключить API вместо симуляции.
    let tasks = [
      TaskItem(id: 1, todo: "Do something nice for someone you care about", completed: false, userId: 152),
      TaskItem(id: 2, todo: "Memorize a poem", completed: true, userId: 13),
      TaskItem(id: 3, todo: "Watch a classic movie", completed: true, userId: 68)
    ]

    TaskService.shared.loadPhoto(completion: { _ in })
    output?.didFetchTasks(tasks)
  }
}

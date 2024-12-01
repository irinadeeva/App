//
//  TaskItemResponse.swift
//  ToDoApp
//
//  Created by Irina Deeva on 01/12/24.
//

import Foundation

struct TaskItemResponse: Codable {
  let id: Int
  let todo: String
  let completed: Bool
}

extension TaskItemResponse {
  func toTaskItem(description: String? = nil, createdAt: Date? = nil) -> TaskItem {
    TaskItem(
      id: self.id,
      todo: self.todo,
      completed: self.completed,
      description: description,
      createdAt: createdAt
    )
  }
}

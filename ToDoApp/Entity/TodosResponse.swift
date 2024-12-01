//
//  TodosResponse.swift
//  ToDoApp
//
//  Created by Irina Deeva on 30/11/24.
//

import Foundation

struct TodosResponse: Codable {
  let todos: [TaskItemResponse]
}

extension Array where Element == TaskItemResponse {
    func toTaskItems(description: String? = nil, createdAt: Date? = nil) -> [TaskItem] {
        return self.map { $0.toTaskItem(description: description, createdAt: createdAt) }
    }
}

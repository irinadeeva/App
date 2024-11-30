//
//  TodosResponse.swift
//  ToDoApp
//
//  Created by Irina Deeva on 30/11/24.
//

import Foundation

struct TodosResponse: Codable {
  let todos: [TaskItem]
//    let total: Int
//    let skip: Int
//    let limit: Int
}

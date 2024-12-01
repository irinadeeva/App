//
//
//  ToDo
//
//  Created by Irina Deeva on 28/11/24.
//

import Foundation

struct TaskItem: Codable {
  let id: Int
  let todo: String
  let completed: Bool
  let description: String?
  let createdAt: Date?
}

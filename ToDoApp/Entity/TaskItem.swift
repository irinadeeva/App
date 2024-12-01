//
//
//  ToDo
//
//  Created by Irina Deeva on 28/11/24.
//

import Foundation

struct TaskItem: Codable {
  let id: UUID
  let todo: String
  var completed: Bool
  let description: String?
  let createdAt: Date?
}

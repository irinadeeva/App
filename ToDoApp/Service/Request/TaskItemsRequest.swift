//
//  TaskItemsRequest.swift
//  ToDoApp
//
//  Created by Irina Deeva on 01/12/24.
//

import Foundation

struct TaskItemsRequest: NetworkRequest {
  var endpoint = "\(RequestConstants.baseURL)"

  var httpMethod: HttpMethod { .get }
}

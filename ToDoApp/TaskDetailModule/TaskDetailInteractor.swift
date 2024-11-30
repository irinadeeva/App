//
//  TaskDetailInteractor.swift
//
//  Created by Irina Deeva on 30/11/24
//

protocol TaskDetailInteractorInput: AnyObject {
}

protocol TaskDetailInteractorOutput: AnyObject {
}

final class TaskDetailInteractor: TaskDetailInteractorInput {
  weak var output: TaskDetailInteractorOutput?
}

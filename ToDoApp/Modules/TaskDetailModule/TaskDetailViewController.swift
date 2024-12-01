//
//  TaskDetailViewController.swift
//
//  Created by Irina Deeva on 30/11/24
//

import UIKit

protocol TaskDetailViewProtocol: AnyObject, ErrorView, LoadingView {
}

final class TaskDetailViewController: UIViewController {
  // MARK: - Public
  var presenter: TaskDetailPresenterProtocol?

  lazy var activityIndicator = UIActivityIndicatorView()

  private let task: TaskItem

  init(task: TaskItem) {
    self.task = task
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    initialize()
  }
}

// MARK: - Private functions
private extension TaskDetailViewController {
  func initialize() {
  }
}

// MARK: - TaskDetailViewProtocol
extension TaskDetailViewController: TaskDetailViewProtocol {
}

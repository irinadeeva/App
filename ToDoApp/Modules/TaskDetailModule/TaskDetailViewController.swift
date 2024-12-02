//
//  TaskDetailViewController.swift
//
//  Created by Irina Deeva on 30/11/24
//

import UIKit

protocol TaskDetailViewProtocol: AnyObject, ErrorView, LoadingView {
  func showTask(_ task: TaskItem)
}

final class TaskDetailViewController: UIViewController {
  // MARK: - Public
  var presenter: TaskDetailPresenterProtocol?

  lazy var activityIndicator = UIActivityIndicatorView()
  private var taskItem: TaskItem?

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.textColor = UIColor(resource: .customStroke)
    return label
  }()

  private let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.textColor = UIColor(resource: .customWhite)
    textView.backgroundColor = .clear
    textView.isEditable = true
    textView.isScrollEnabled = true
    textView.textAlignment = .left
    return textView
  }()

  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter?.viewDidLoad()
  }
}

// MARK: - Private functions
private extension TaskDetailViewController {
  func setup() {
    view.backgroundColor = UIColor(resource: .customBlack)

    navigationController?.navigationBar.prefersLargeTitles = true

    view.addSubview(dateLabel)
    view.addSubview(descriptionTextView)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
      dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
      descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
    ])
  }
}

// MARK: - TaskDetailViewProtocol
extension TaskDetailViewController: TaskDetailViewProtocol {
  func showTask(_ task: TaskItem) {
    taskItem = task
    title = task.todo

    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    if let createdAt = task.createdAt {
      dateLabel.text = formatter.string(from: createdAt)
    } else {
      dateLabel.text = formatter.string(from: Date())
    }

    descriptionTextView.text = task.description ?? "No Description"
  }
}

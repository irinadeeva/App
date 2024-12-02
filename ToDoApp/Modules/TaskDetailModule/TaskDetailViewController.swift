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

  private let titleTextField: UITextField = {
    let textField = UITextField()
    textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    textField.textColor = UIColor(resource: .customWhite)
    textField.textAlignment = .left
    textField.placeholder = "Enter Title"
    textField.backgroundColor = .clear
    textField.borderStyle = .none
    return textField
  }()

  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter?.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    guard let taskItem else { return }
    let updatedTask = TaskItem(
      id: taskItem.id, // Используем текущий ID или создаём новый
      todo: titleTextField.text ?? "",
      completed: taskItem.completed,       // Текст заголовка
      description: descriptionTextView.text,// Текст описания
      createdAt: taskItem.createdAt        // Дата создания остаётся неизменной
    )

    presenter?.viewWillDisappear(updatedTask)
  }
}

// MARK: - Private functions
private extension TaskDetailViewController {
  func setup() {
    view.backgroundColor = UIColor(resource: .customBlack)

    view.addSubview(titleTextField)
    view.addSubview(dateLabel)
    view.addSubview(descriptionTextView)
    view.addSubview(activityIndicator)

    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
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
    titleTextField.text = task.todo

    if let createdAt = task.createdAt {
        dateLabel.text = DateFormatter.mediumDateFormatter.string(from: createdAt)
    } else {
        dateLabel.text = ""
    }

    descriptionTextView.text = task.description ?? ""
  }
}

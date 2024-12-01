//
//  TaskListViewController.swift
//
//  Created by Irina Deeva on 29/11/24
//

import UIKit

protocol TaskListViewProtocol: AnyObject, ErrorView, LoadingView {
  func showTasks(_ tasks: [TaskItem])
}

final class TaskListViewController: UIViewController {
  
  // MARK: - Public
  var presenter: TaskListPresenterProtocol?
  lazy var activityIndicator = UIActivityIndicatorView()

  private let tableView = UITableView()
  private var tasks: [TaskItem] = []
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .customBlack)

    setupTableView()
    presenter?.viewDidLoad()
  }
}

// MARK: - Private functions
private extension TaskListViewController {
  func  setupTableView() {
    view.addSubview(tableView)
    view.addSubview(activityIndicator)
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}

// MARK: - TaskListViewProtocol
extension TaskListViewController: TaskListViewProtocol {
  func showTasks(_ tasks: [TaskItem]) {
    self.tasks = tasks
    tableView.reloadData()
  }
}

extension TaskListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

    let task = tasks[indexPath.row]

    cell.configure(with: task){}
    return cell
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    presenter?.didSelectTask(task)
  }
}






final class TaskTableViewCell: UITableViewCell {

  private let circleButton: UIButton = {
    let button = UIButton()
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor(resource: .customYellow).cgColor
    button.layer.cornerRadius = 15
    return button
  }()

  private let taskNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = UIColor(resource: .customWhite)
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = UIColor(resource: .customWhite)
    label.numberOfLines = 0
    return label
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = UIColor(resource: .customWhite)
    return label
  }()

  // MARK: - Setup
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.backgroundColor = UIColor(resource: .customBlack)

    contentView.addSubview(circleButton)
    contentView.addSubview(taskNameLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(dateLabel)

    // Layout constraints for the circle and labels
    circleButton.translatesAutoresizingMaskIntoConstraints = false
    taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      circleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      circleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      circleButton.widthAnchor.constraint(equalToConstant: 30),
      circleButton.heightAnchor.constraint(equalToConstant: 30),

      taskNameLabel.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 16),
      taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

      descriptionLabel.leadingAnchor.constraint(equalTo: taskNameLabel.leadingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 4),
      descriptionLabel.trailingAnchor.constraint(equalTo: taskNameLabel.trailingAnchor),

      dateLabel.leadingAnchor.constraint(equalTo: taskNameLabel.leadingAnchor),
      dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
      dateLabel.trailingAnchor.constraint(equalTo: taskNameLabel.trailingAnchor),
      dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure
  func configure(with task: TaskItem, toggleCompletionAction: @escaping () -> Void) {
    taskNameLabel.text = task.todo
    descriptionLabel.text = task.description ?? "No description available"
    dateLabel.text = task.createdAt != nil ? "\(task.createdAt!)" : "No date provided"

    // Circle (checkbox) setup
//    circleButton.layer.borderColor = task.completed ? UIColor.green.cgColor : UIColor.gray.cgColor
    circleButton.addTarget(self, action: #selector(didTapCircleButton), for: .touchUpInside)

    // Strike-through if task is completed
    let attributeString: NSMutableAttributedString
    if task.completed {
      attributeString = NSMutableAttributedString(string: task.todo)
      attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: task.todo.count))
    } else {
      attributeString = NSMutableAttributedString(string: task.todo)
    }
    taskNameLabel.attributedText = attributeString
  }

  @objc private func didTapCircleButton() {
    // Action to toggle completion status (communicate with the controller/presenter)
//    toggleCompletionAction()
  }
}

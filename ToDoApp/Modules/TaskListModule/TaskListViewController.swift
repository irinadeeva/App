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
  private let searchController = UISearchController(searchResultsController: nil)
  private let tableView = UITableView()
  private var filteredTasks: [TaskItem] = []
  private var tasks: [TaskItem] = []


  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()

    presenter?.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    presenter?.viewWillAppear()
  }
}

// MARK: - Private functions
private extension TaskListViewController {
  func  setup() {
    view.backgroundColor = UIColor(resource: .customBlack)
    title = "Task List"
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.prefersLargeTitles = true

    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor(resource: .customBlack)
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor(resource: .customWhite)
    ]
    appearance.largeTitleTextAttributes = [
      .foregroundColor: UIColor(resource: .customWhite)
    ]

    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.compactAppearance = appearance


    let addTaskButton  = UIBarButtonItem(
      image: UIImage(systemName: "square.and.pencil"),
      style: .plain,
      target: self,
      action: #selector(didTapAddTaskButton)
    )

    navigationController?.navigationBar.topItem?.rightBarButtonItem = addTaskButton

    searchController.searchResultsUpdater = self
    searchController.searchBar.tintColor = UIColor(resource: .customWhite)
    searchController.searchBar.searchTextField.backgroundColor = UIColor(resource: .customGrey)
    searchController.searchBar.searchTextField.textColor = .white
    searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
        string: "Search Tasks",
        attributes: [
          .foregroundColor: UIColor(resource: .customStroke)
        ]
    )

    let searchBarAppearance = searchController.searchBar
    searchBarAppearance.barTintColor = UIColor(resource: .customBlack)
    searchBarAppearance.backgroundImage = UIImage()
    searchBarAppearance.isTranslucent = false

    navigationItem.searchController = searchController


    if let tabBarController = tabBarController {
      let tabBarAppearance = UITabBarAppearance()
      tabBarAppearance.configureWithOpaqueBackground()
      tabBarAppearance.backgroundColor = UIColor(resource: .customGrey)

      tabBarController.tabBar.standardAppearance = tabBarAppearance
      tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance

      tabBarController.tabBar.tintColor = UIColor(resource: .customWhite)
      tabBarController.tabBar.unselectedItemTintColor = .lightGray
    }

    view.addSubview(tableView)
    view.addSubview(activityIndicator)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    tableView.backgroundColor = UIColor(resource: .customBlack)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  func updateTabBarItem() {
    if let tabBarController = tabBarController {
      let taskCount = filteredTasks.count
      let taskCountText = taskCount == 1 ? "1 task" : "\(taskCount) tasks"
      tabBarController.tabBar.items?[0].title = taskCountText
    }
  }

  @objc private func didTapAddTaskButton() {
    presenter?.addNewTask()
  }
}

// MARK: - TaskListViewProtocol
extension TaskListViewController: TaskListViewProtocol {
  func showTasks(_ tasks: [TaskItem]) {
    self.filteredTasks = tasks
    self.tasks = tasks
    tableView.reloadData()
    updateTabBarItem()
  }
}

extension TaskListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredTasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

    let task = filteredTasks[indexPath.row]
    cell.prepareForReuse()
    cell.configure(with: task)
    cell.delegate = self
    return cell
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = filteredTasks[indexPath.row]
    presenter?.didSelectTask(task)
  }
}

extension TaskListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
      filteredTasks = tasks
      tableView.reloadData()
      updateTabBarItem()
      return
    }

    filteredTasks = tasks.filter { task in
      task.todo.lowercased().contains(searchText) ||
      (task.description?.lowercased().contains(searchText) ?? false)
    }

    tableView.reloadData()
    updateTabBarItem()
  }
}

extension TaskListViewController: TaskTableViewCellDelegate {
  func didTapEditCell(_ cell: TaskTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let task = filteredTasks[indexPath.row]
    presenter?.didSelectTask(task)
  }

  func didTapDeleteCell(_ cell: TaskTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let task = filteredTasks[indexPath.row]

    presenter?.didTaskDeleted(task)
  }

  func didTapShareCell(_ cell: TaskTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let task = filteredTasks[indexPath.row]

    presenter?.didTapShareCell(task)
  }

  func didToggleCompletion(for cell: TaskTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let task = filteredTasks[indexPath.row]

    presenter?.didTaskCompleted(task)
  }
}

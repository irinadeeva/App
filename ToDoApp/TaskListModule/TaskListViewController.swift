//
//  TaskListViewController.swift
//
//  Created by Irina Deeva on 29/11/24
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
  func showTasks(_ tasks: [TaskItem])
}

final class TaskListViewController: UIViewController {
  
  // MARK: - Public
  var presenter: TaskListPresenterProtocol?
  private let tableView = UITableView()
  
  private var tasks: [TaskItem] = []
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    presenter?.viewDidLoad()
  }
}

// MARK: - Private functions
private extension TaskListViewController {
  func  setupTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let task = tasks[indexPath.row]
    cell.textLabel?.text = task.todo
    cell.accessoryType = task.completed ? .checkmark : .none
    return cell
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    presenter?.didSelectTask(task)
  }
}

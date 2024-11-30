////
////  View.swift
////  ToDo
////
////  Created by Irina Deeva on 28/11/24.
////
//
//import UIKit
//
////ViewController
//// protocol
//// reference presenter
////protocol AnyView: AnyObject{
////  var presenter: AnyPresenter? { get set }
////  func update(with users: [User])
////  func update(with error: String)
////}
////
////
////class UserViewController: UIViewController, AnyView {
////  var presenter: (any AnyPresenter)?
////
////  func update(with users: [User]) {
////    <#code#>
////  }
////  
////  func update(with error: String) {
////    <#code#>
////  }
////  
////
////}
//
//protocol TaskListViewInput: AnyObject {
//    func displayTasks(_ tasks: [Task])
//}
//
//final class TaskListViewController: UIViewController, TaskListViewInput {
//    var presenter: TaskListViewOutput?
//
//    private var tasks: [Task] = []
//    private let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        presenter?.viewDidLoad()
//    }
//
//    private func setupTableView() {
//        view.addSubview(tableView)
//        tableView.frame = view.bounds
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//    }
//
//    func displayTasks(_ tasks: [Task]) {
//        self.tasks = tasks
//        tableView.reloadData()
//    }
//}
//
//extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let task = tasks[indexPath.row]
//        cell.textLabel?.text = task.todo
//        cell.accessoryType = task.completed ? .checkmark : .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let task = tasks[indexPath.row]
//        presenter?.didSelectTask(task)
//    }
//}
//
//final class TaskDetailViewController: UIViewController {
//    private let task: Task
//
//    private let titleLabel = UILabel()
//    private let statusLabel = UILabel()
//
//    init(task: Task) {
//        self.task = task
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        displayTaskDetails()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//        titleLabel.textAlignment = .center
//        statusLabel.textAlignment = .center
//
//        let stack = UIStackView(arrangedSubviews: [titleLabel, statusLabel])
//        stack.axis = .vertical
//        stack.spacing = 16
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(stack)
//
//        NSLayoutConstraint.activate([
//            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//    }
//
//    private func displayTaskDetails() {
//        titleLabel.text = "Task: \(task.todo)"
//        statusLabel.text = "Completed: \(task.completed ? "Yes" : "No")"
//    }
//}

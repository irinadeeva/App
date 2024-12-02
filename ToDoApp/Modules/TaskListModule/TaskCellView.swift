//
//  TaskCellView.swift
//  ToDoApp
//
//  Created by Irina Deeva on 02/12/24.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
  func didToggleCompletion(for cell: TaskTableViewCell)
  func didTapEditCell(_ cell: TaskTableViewCell)
  func didTapDeleteCell(_ cell: TaskTableViewCell)
  func didTapShareCell(_ cell: TaskTableViewCell)
}

final class TaskTableViewCell: UITableViewCell {
  weak var delegate: TaskTableViewCellDelegate?

  private let circleButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor(resource: .customYellow).cgColor
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

    let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
    contentView.addInteraction(contextMenuInteraction)

    contentView.addSubview(circleButton)
    contentView.addSubview(taskNameLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(dateLabel)

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

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  // MARK: - Configure
  func configure(with task: TaskItem) {
    taskNameLabel.text = task.todo
    descriptionLabel.text = task.description ?? ""

    if let createdAt = task.createdAt {
      dateLabel.text = DateFormatter.mediumDateFormatter.string(from: createdAt)
    } else {
      dateLabel.text = ""
    }

    circleButton.addTarget(self, action: #selector(didTapCircleButton), for: .touchUpInside)

    let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
    if task.completed {
      circleButton.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: imageConfiguration), for: .normal)
    } else {
      circleButton.setImage(UIImage(systemName: "circle", withConfiguration: imageConfiguration), for: .normal)
    }

    let strokeColor = UIColor(resource: .customStroke)
    taskNameLabel.textColor = task.completed ? strokeColor : UIColor(resource: .customWhite)
    descriptionLabel.textColor = task.completed ? strokeColor : UIColor(resource: .customWhite)
    dateLabel.textColor = task.completed ? strokeColor : UIColor(resource: .customWhite)
  }

  @objc private func didTapCircleButton() {
    delegate?.didToggleCompletion(for: self)
  }
}

extension TaskTableViewCell: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
      let edit = UIAction(
        title: "Edit",
        image: UIImage(systemName: "square.and.pencil")
      ) { _ in
        self.delegate?.didTapEditCell(self)
      }

      let share = UIAction(
        title: "Share",
        image: UIImage(systemName: "square.and.arrow.up")
      ) { _ in
        self.delegate?.didTapShareCell(self)
      }

      let delete = UIAction(
        title: "Delete",
        image: UIImage(systemName: "trash"),
        attributes: .destructive
      ) { _ in
        self.delegate?.didTapDeleteCell(self)
      }

      return UIMenu(title: "", children: [edit, share, delete])
    }
  }
}

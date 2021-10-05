//
//  ReminderDetailViewController.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
  
  private var reminder: Reminder?
  private var dataSource: UITableViewDataSource?

  override func viewDidLoad() {
    super.viewDidLoad()
    setEditing(false, animated: false)
    navigationItem.setRightBarButton(editButtonItem, animated: false)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    guard let reminder = reminder else {
      fatalError("No reminder found for detail view")
    }
    if editing {
      dataSource = ReminderDetailEditDataSource(reminder: reminder) { reminder in
        self.editButtonItem.isEnabled = true
      }
      navigationItem.title = NSLocalizedString("Edit Reminder", comment: "edit reminder nav title")
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                         target: self,
                                                         action: #selector(cancelButtonTrigger))
    } else {
      dataSource = ReminderDetailViewDataSource(reminder: reminder)
      navigationItem.title = NSLocalizedString("View Reminder", comment: "View reminder nav title")
      navigationItem.leftBarButtonItem = nil
      editButtonItem.isEnabled = true
    }
    tableView.dataSource = dataSource
    tableView.reloadData()
  }

  @objc
  func cancelButtonTrigger() {
    setEditing(false, animated: true)
  }

  func configure(with reminder: Reminder) {
    self.reminder = reminder
  }

}

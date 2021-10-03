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
      dataSource = ReminderDetailEditDataSource(reminder: reminder)
    } else {
      dataSource = ReminderDetailViewDataSource(reminder: reminder)
    }
    tableView.dataSource = dataSource
    tableView.reloadData()
  }

  func configure(with reminder: Reminder) {
    self.reminder = reminder
  }

}

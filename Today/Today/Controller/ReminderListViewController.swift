//
//  ViewController.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class ReminderListViewController: UITableViewController {

  private var reminderListDataSource: ReminderListDataSource?

  static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
  static let mainStoryboardName = "Main"
  static let detailViewControllerIdentifier = "ReminderDetailViewController"

  override func viewDidLoad() {
    super.viewDidLoad()
    reminderListDataSource = ReminderListDataSource()
    tableView.dataSource = reminderListDataSource
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let navigationController = navigationController,
       navigationController.isToolbarHidden {
      navigationController.setToolbarHidden(false, animated: animated)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Self.showDetailSegueIdentifier,
       let destination = segue.destination as? ReminderDetailViewController,
       let cell = sender as? UITableViewCell,
       let indexPath = tableView.indexPath(for: cell) {
      let rowIndex = indexPath.row
      guard let reminder = reminderListDataSource?.reminder(at: rowIndex) else {
        fatalError("Couldn't find data source for reminder list")
      }
      destination.configure(with: reminder, editAction: { reminder in
        self.reminderListDataSource?.update(reminder, at: rowIndex)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      })
    }
  }

  @IBAction func addButtonTriggered(_ sender: Any) {
    addReminder()
  }

  private func addReminder() {
    let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
    let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
    let reminder = Reminder(title: "New Reminder", dueDate: Date())
    detailViewController.configure(with: reminder, isNew: true, addAction: { reminder in

    })

    let navigationController = UINavigationController(rootViewController: detailViewController)
    present(navigationController, animated: true, completion: nil)
  }

}

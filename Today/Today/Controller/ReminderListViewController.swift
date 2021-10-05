//
//  ViewController.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class ReminderListViewController: UITableViewController {

  private var reminderListDataSource: ReminderListDataSource?
  private var filter: ReminderListDataSource.Filter {
    ReminderListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
  }

  @IBOutlet var filterSegmentedControl: UISegmentedControl!
  @IBOutlet var progressContainerView: UIView!
  @IBOutlet var percentCompleteView: UIView!
  @IBOutlet var percentIncompleteView: UIView!
  @IBOutlet var percentCompleteHeightConstraint: NSLayoutConstraint!

  static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
  static let mainStoryboardName = "Main"
  static let detailViewControllerIdentifier = "ReminderDetailViewController"

  override func viewDidLoad() {
    super.viewDidLoad()
    reminderListDataSource = ReminderListDataSource()
    tableView.dataSource = reminderListDataSource
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let radius = view.bounds.size.width * 0.5 * 0.7
    progressContainerView.layer.cornerRadius = radius
    progressContainerView.layer.masksToBounds = true
    refreshProgressView()
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
        self.tableView.reloadData()
        self.refreshProgressView()
      })
    }
  }

  @IBAction func addButtonTriggered(_ sender: Any) {
    addReminder()
  }

  @IBAction func segmentControlChanged(_ sender: Any) {
    reminderListDataSource?.filter = filter
    tableView.reloadData()
    refreshProgressView()
  }

  private func addReminder() {
    let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
    let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
    let reminder = Reminder(id: UUID().uuidString, title: "New Reminder", dueDate: Date())
    detailViewController.configure(with: reminder, isNew: true, addAction: { reminder in
      if let index = self.reminderListDataSource?.add(reminder) {
        self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
      }
      self.refreshProgressView()
    })

    let navigationController = UINavigationController(rootViewController: detailViewController)
    present(navigationController, animated: true, completion: nil)
  }

  private func refreshProgressView() {
    guard let percentComplete = reminderListDataSource?.percentComplete else {
      return
    }
    let totalHeight = progressContainerView.bounds.size.height
    percentCompleteHeightConstraint.constant = totalHeight * percentComplete
    UIView.animate(withDuration: 0.2) {
      self.progressContainerView.layoutSubviews()
    }
  }

}

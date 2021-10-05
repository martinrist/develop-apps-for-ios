//
//  ReminderListDataSource.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class ReminderListDataSource: NSObject {
  private lazy var dateFormatter = RelativeDateTimeFormatter()

  enum Filter: Int {
    case today
    case future
    case all

    func shouldInclude(date: Date) -> Bool {
      let isInToday = Locale.current.calendar.isDateInToday(date)
      switch self {
      case .today:
        return isInToday
      case .future:
        return date > Date() && !isInToday
      case .all:
        return true
      }
    }
  }

  var filter: Filter = .today

  var filteredReminders: [Reminder] {
    Reminder.testData
      .filter { filter.shouldInclude(date: $0.dueDate) }
      .sorted { $0.dueDate < $1.dueDate }
  }

  func reminder(at row: Int) -> Reminder {
    return filteredReminders[row]
  }

  func update(_ reminder: Reminder, at row: Int) {
    Reminder.testData[row] = reminder
  }

  func add(_ reminder: Reminder) {
    Reminder.testData.insert(reminder, at: 0)
  }

}

extension ReminderListDataSource: UITableViewDataSource {
  static let reminderListCellIdentifier = "ReminderListCell"

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredReminders.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reminderListCellIdentifier, for: indexPath) as? ReminderListCell else {
      fatalError("Unable to dequeue ReminderCell)")
    }
    let reminder = Reminder.testData[indexPath.row]
    let dateText = dateFormatter.localizedString(for: reminder.dueDate, relativeTo: Date())
    cell.configure(title: reminder.title,
                   dateText: dateText,
                   isDone: reminder.isComplete) {
      Reminder.testData[indexPath.row].isComplete.toggle()
      tableView.reloadRows(at: [indexPath], with: .none)
    }
    return cell
  }
}

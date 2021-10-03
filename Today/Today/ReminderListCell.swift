//
//  ReminderListCell.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class ReminderListCell: UITableViewCell {

  typealias DoneButtonAction = () -> Void

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet var doneButton: UIButton!
  @IBOutlet var dateLabel: UILabel!

  var doneButtonAction: DoneButtonAction?

  @IBAction func doneButtonTriggered(_ sender: UIButton) {
    doneButtonAction?()
  }
}

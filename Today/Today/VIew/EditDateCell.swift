//
//  EditDateCell.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class EditDateCell: UITableViewCell {

  @IBOutlet var datePicker: UIDatePicker!

  func configure(date: Date) {
    datePicker.date = date
  }
}

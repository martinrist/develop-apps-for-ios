//
//  EditTitleCell.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class EditTitleCell: UITableViewCell {
  @IBOutlet var titleTextField: UITextField!

  func configure(title: String) {
    titleTextField.text = title
  }
}

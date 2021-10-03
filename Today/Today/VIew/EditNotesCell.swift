//
//  EditNotesCell.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class EditNotesCell: UITableViewCell {

  @IBOutlet var notesTextView: UITextView!

  func configure(notes: String?) {
    notesTextView.text = notes
  }
}

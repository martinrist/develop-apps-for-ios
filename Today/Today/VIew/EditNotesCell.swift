//
//  EditNotesCell.swift
//  Today
//
//  Created by Martin Rist on 03/10/2021.
//

import UIKit

class EditNotesCell: UITableViewCell {

  typealias NotesChangeAction = (String) -> Void

  @IBOutlet var notesTextView: UITextView!

  private var notesChangeAction: NotesChangeAction?

  override func awakeFromNib() {
    super.awakeFromNib()
    notesTextView.delegate = self
  }

  func configure(notes: String?, changeAction: NotesChangeAction?) {
    notesTextView.text = notes
    self.notesChangeAction = changeAction
  }
}

extension EditNotesCell: UITextViewDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let originalText = textField.text {
      let changedText = (originalText as NSString).replacingCharacters(in: range, with: string)
      notesChangeAction?(changedText)
    }
    return true
  }
}

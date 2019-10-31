//
//  AddNoteViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var addNotesButton: UIButton!
    
    var gameID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.becomeFirstResponder()
        addNotesButton.layer.cornerRadius = addNotesButton.frame.height / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        guard let noteText = noteTextView.text, !noteText.isEmpty, let gameID = gameID, let userUUID = UserController.shared.currentUser?.uuid else { return }
        let note = Note(noteUUID: UUID().uuidString, note: noteText, userUUID: userUUID, timestamp: Date().timeIntervalSince1970, gameID: gameID)
        NoteController.shared.createNote(note: note) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func screenTapped() {
        dismiss(animated: true, completion: nil)
    }
}

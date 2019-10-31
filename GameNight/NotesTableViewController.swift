//
//  NotesTableViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var gameID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let gameID = gameID, let userID = UserController.shared.currentUser?.uuid else { return }
        NoteController.shared.fetchNotesForGame(gameID: gameID, userID: userID) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func notesButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addNoteVC") as? AddNoteViewController, let gameID = gameID else { return }
        destinationVC.gameID = gameID
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: false)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteController.shared.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view 
        let note = NoteController.shared.notes[indexPath.row]
        cell.textLabel?.text = note.note
        cell.detailTextLabel?.text = Date(timeIntervalSince1970: note.timestamp).stringWith(dateStyle: .medium, timeStyle: .none)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = NoteController.shared.notes[indexPath.row]
            NoteController.shared.deleteNote(note: note) { (success) in
                if success {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

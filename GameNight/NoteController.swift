//
//  NoteController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation
import Firebase

class NoteController {
    
    static let shared = NoteController()
    
    var notes: [Note] = []
    
    let collectionPath = "notes"
    
    func createNote(note: Note, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(note.noteUUID).setData(note.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func deleteNote(note: Note, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(note.noteUUID).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                if let index = self.notes.firstIndex(of: note) {
                    self.notes.remove(at: index)
                }
                completion(true)
            }
        }
    }
    
    func fetchNotesForGame(gameID: String, userID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).whereField("gameID", isEqualTo: gameID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let snapshot = snapshot else { completion(false); return }
            self.notes.removeAll()
            for child in snapshot.documents {
                if let note = Note(dictionary: child.data()) {
                    self.notes.append(note)
                }
            }
            self.notes.sort(by: { $0.timestamp > $1.timestamp })
            completion(true)
        }
    }
}

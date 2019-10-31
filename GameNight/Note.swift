//
//  Note.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation

class Note {
    
    let noteUUID: String
    let note: String
    let userUUID: String
    let timestamp: Double
    let gameID: String
    
    init(noteUUID: String, note: String, userUUID: String, timestamp: Double, gameID: String) {
        self.noteUUID = noteUUID
        self.note = note
        self.userUUID = userUUID
        self.timestamp = timestamp
        self.gameID = gameID
    }
    
    var dictionary: [String: Any] {
        return [
        "noteUUID" : noteUUID,
        "note" : note,
        "userUUID" : userUUID,
        "timestamp" : timestamp,
        "gameID" : gameID
        ]
    }
}

extension Note {
    convenience init?(dictionary: [String: Any]) {
        guard let noteUUID = dictionary["noteUUID"] as? String,
        let note = dictionary["note"] as? String,
        let userUUID = dictionary["userUUID"] as? String,
        let timestamp = dictionary["timestamp"] as? Double,
        let gameID = dictionary["gameID"] as? String
            else { return nil }
        
        self.init(noteUUID: noteUUID, note: note, userUUID: userUUID, timestamp: timestamp, gameID: gameID)
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.noteUUID == rhs.noteUUID
    }
}

//
//  FirebaseGameController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/24/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation
import Firebase

class FirebaseGameController {
    
    static let shared = FirebaseGameController()
    
    var usersWishListGames: [FirebaseGame] = []
    
    var usersOwnGames: [FirebaseGame] = []
    
    let collectionPath = "games"
    
    func saveGame(game: FirebaseGame, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(game.uuid).setData(game.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func checkToSeeIfGameExists(gameID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(gameID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let snapshotdata = snapshot?.data() else { completion(false); return }
            if let game =  FirebaseGame(dictionary: snapshotdata) {
                print(game.gameName)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func addUserToWishListArray(userUUID: String, gameID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(gameID).updateData(["wishListUsers" : FieldValue.arrayUnion([userUUID])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func addUserToOwnGameArray(userUUID: String, gameID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(gameID).updateData(["ownUsers" : FieldValue.arrayUnion([userUUID])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func fetchUsersWishListGames(userUUID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).whereField("wishListUsers", arrayContains: userUUID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let snapshot = snapshot else { completion(false); return }
            self.usersWishListGames.removeAll()
            for child in snapshot.documents {
                if let game = FirebaseGame(dictionary: child.data()) {
                    self.usersWishListGames.append(game)
                }
            }
            completion(true)
        }
    }
    
    func fetchUsersOwnedGames(userUUID: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).whereField("ownUsers", arrayContains: userUUID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let snapshot = snapshot else { completion(false); return }
            self.usersOwnGames.removeAll()
            for child in snapshot.documents {
                if let game = FirebaseGame(dictionary: child.data()) {
                    self.usersOwnGames.append(game)
                }
            }
            self.usersOwnGames.sort(by: { $0.gameName < $1.gameName })
            completion(true)
        }
    }
    
    func findRandomGame(numberOfPlayers: Int, playtime: Int, minAge: Int) -> [FirebaseGame] {
        var gamesThatFit: [FirebaseGame] = []
        for game in self.usersOwnGames {
            if let gameMinAge = game.minAge {
                if minAge >= gameMinAge {
                    if let gameMinPlayer = game.minPlayers, let gameMaxPlayers = game.maxPlayers {
                        if gameMinPlayer <= numberOfPlayers && gameMaxPlayers >= numberOfPlayers {
                            if let gameMinTime = game.minPlaytime, let gameMaxTime = game.maxPlaytime {
                                if gameMinTime <= playtime && gameMaxTime >= playtime {
                                    gamesThatFit.append(game)
                                }
                            }
                        }
                    }
                }
            }
        }
        return gamesThatFit
    }
    
    func removeOwnedGame(with UUID: String, gameID: String, completion: @escaping  (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(gameID).updateData(["ownUsers" : FieldValue.arrayRemove([UUID])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func removeFromWishList(with UUID: String, gameID: String, completion: @escaping  (Bool) -> Void) {
        Firestore.firestore().collection(collectionPath).document(gameID).updateData(["wishListUsers" : FieldValue.arrayRemove([UUID])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
}

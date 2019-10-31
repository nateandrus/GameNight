//
//  UserController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/24/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let shared = UserController()
    
    let userCollection = "BoardGamers"
    var currentUser: User?
    
    func createFirebaseUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            guard let data = authData else { completion(nil, error); return }
            let firebaseUUID = data.user.uid
            completion(firebaseUUID, nil)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            guard let authData = authData else { completion(nil, error); return }
            let firebaseUID = authData.user.uid
            completion(firebaseUID, nil)
        }
    }
    
    func loadUser(firebaseUID: String, completion: @escaping (User?) -> Void) {
        Firestore.firestore().collection(userCollection).document(firebaseUID).getDocument { (docSnapshot, error) in
            if let error = error {
                print("Could not find a teacher with that userID: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let docSnapshot = docSnapshot else { completion(nil); return }
            if docSnapshot.exists {
                let user = User(dictionary: docSnapshot.data()!)
                self.currentUser = user
                completion(user)
            }
        }
    }
    
    
    func createGameNightUser(user: User, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(self.userCollection).document(user.uuid).setData(user.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            self.currentUser = user
            completion(true)
        }
    }
    
    func updateProfileImageFor(userID: String, usingImage: UIImage, completion: @escaping (Bool) -> Void) {
        let resizedImage = PhotoResizer.ResizeImage(image: usingImage, targetSize: CGSize(width: 400, height: 400))
        let storage = Storage.storage().reference().child(userID)
        guard let uploadData = resizedImage.pngData() else { return }
        print(resizedImage.size)
        storage.putData(uploadData, metadata: nil) {(metaData, error) in
            if let error = error {
                print("\(error.localizedDescription)🤬🤬🤬🤬🤬")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func loadProfileImageForUser(withUUID: String, completion: @escaping (UIImage?) -> Void) {
        let urlReference = Storage.storage().reference().child(withUUID)
        urlReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error fetching image from URL :: \(error.localizedDescription)💩💩💩💩💩💩")
                completion(nil)
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            completion(image)
            return
        }
    }
}

//
//  User.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit


class User {
    
    let username: String
    let email: String
    let uuid: String
    let selfDocReference: DocumentReference
    let profileImageURL: String?
    let profileImage: UIImage?
    
    init(username: String, profileImageURL: String?, profileImage: UIImage?) {
        self.username = username
        self.profileImageURL = profileImageURL
        self.profileImage = profileImage
    }
    
    var dictionary: [String: Any] {
        return [
            "username" : username,
            "email" : email,
            "uuid" : uuid,
            "selfDocRef" : selfDocReference,
            "profileImageURL" : profileImageURL
            
        ]
    }
}

extension User {
    convenience init?(dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String,
            let firebaseUID = dictionary["uuid"] as? String,
            let selfDocReference = dictionary["selfDocRef"] as? DocumentReference
            else { return nil }
        
        let profileImageAsString = dictionary["profileImageURL"] as? String
        let profileImage = dictionary["profileImage"] as? UIImage

        self.init(
    }
}

//
//  User.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import Firebase

class User {

    let username: String
    let email: String
    let uuid: String
    let profileImageURL: String
    let profileImage: UIImage?

    init(username: String, email: String, uuid: String, profileImageURL: String, profileImage: UIImage?) {
        self.username = username
        self.email = email
        self.uuid = uuid
        self.profileImageURL = profileImageURL
        self.profileImage = profileImage
    }

    var dictionary: [String: Any] {
        return [
            "username" : username,
            "email" : email,
            "uuid" : uuid,
            "profileImageURL" : profileImageURL

        ]
    }
}

extension User {
    convenience init?(dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String,
            let firebaseUID = dictionary["uuid"] as? String
            else { return nil }

        let profileImageAsString = dictionary["profileImageURL"] as? String ?? ""
        let profileImage = dictionary["profileImage"] as? UIImage

        self.init(username: username, email: email, uuid: firebaseUID, profileImageURL: profileImageAsString, profileImage: profileImage)
    }
}

//
//  FirebaseGame.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import Firebase

class FirebaseGame {
    
    let uuid: String
    let gameName: String
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let minAge: Int?
    let minPlaytime: Int?
    let maxPlaytime: Int?
    let description: String?
    let imageURL: String?
    let msrp: String?
    let averageRating: Double?
    let rulesURL: String?
    let wishListUsers: [String]
    let ownUsers: [String]
    
    init(uuid: String, gameName: String, yearPublished: Int?, minPlayers: Int?, maxPlayers: Int?, minAge: Int?, minPlaytime: Int?, maxPlaytime: Int?, description: String?, imageURL: String?, msrp: String?, averageRating: Double?, rulesURL: String?, wishListUsers: [String], ownUsers: [String]) {
        self.uuid = uuid
        self.gameName = gameName
        self.yearPublished = yearPublished
        self.minPlayers = minPlayers
        self.maxPlayers = maxPlayers
        self.minAge = minAge
        self.minPlaytime = minPlaytime
        self.maxPlaytime = maxPlaytime
        self.description = description
        self.imageURL = imageURL
        self.msrp = msrp
        self.averageRating = averageRating
        self.rulesURL = rulesURL
        self.wishListUsers = wishListUsers
        self.ownUsers = ownUsers
    }
    
    var dictionary: [String: Any] {
        return [
            "uuid" : uuid,
            "gameName" : gameName,
            "yearPublished" : yearPublished ?? 0,
            "minPlayers" : minPlayers ?? 0,
            "maxPlayers" : maxPlayers ?? 0,
            "minAge" : minAge ?? 0,
            "minPlaytime" : minPlaytime ?? 0,
            "maxPlaytime" : maxPlaytime ?? 0,
            "description" : description ?? "",
            "imageURL" : imageURL ?? "",
            "msrp" : msrp ?? "",
            "averageRating" : averageRating ?? 0,
            "rulesURL" : rulesURL ?? "",
            "wishListUsers" : wishListUsers,
            "ownUsers" : ownUsers
        ]
    }
}

extension FirebaseGame {
    convenience init?(dictionary: [String: Any]) {
        guard let uuid = dictionary["uuid"] as? String,
            let gameName = dictionary["gameName"] as? String
            else { return nil }
        
        let yearPublished = dictionary["yearPublished"] as? Int
        let minPlayers = dictionary["minPlayers"] as? Int
        let maxPlayers = dictionary["maxPlayers"] as? Int
        let minAge = dictionary["minAge"] as? Int
        let minPlaytime = dictionary["minPlaytime"] as? Int
        let maxPlaytime = dictionary["maxPlaytime"] as? Int
        let description = dictionary["description"] as? String
        let imageURL = dictionary["imageURL"] as? String
        let msrp = dictionary["msrp"] as? String
        let averageRating = dictionary["averageRating"] as? Double
        let rulesURL = dictionary["rulesURL"] as? String

        self.init(uuid: uuid, gameName: gameName, yearPublished: yearPublished, minPlayers: minPlayers, maxPlayers: maxPlayers, minAge: minAge, minPlaytime: minPlaytime, maxPlaytime: maxPlaytime, description: description, imageURL: imageURL, msrp: msrp, averageRating: averageRating, rulesURL: rulesURL, wishListUsers: [], ownUsers: [])
    }
}

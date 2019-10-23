//
//  Game.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Decodable {
    
    let games: [Game]
    
    struct Game: Decodable {
        
        let id: String
        let name: String
        let year_published: Int?
        let min_players: Int?
        let max_players: Int?
        let min_age: Int?
        let min_playtime: Int?
        let max_playtime: Int?
        let description: String?
        let thumb_url: String?
        let msrp: String?
        let average_user_rating: Double?
        let rules_url: String?
        
    }
}






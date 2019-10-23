//
//  GameTableViewCell.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var gameLanding: TopLevelDictionary.Game? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let game = gameLanding else { return }
        nameLabel.text = game.name
        ratingLabel.text = "Game rating: \(game.average_user_rating?.rounded(toPlaces: 2) ?? 0)/5"
        descriptionLabel.text = game.description
        if let imageurl = game.thumb_url {
            GameController.shared.fetchImageFor(gameImageURL: imageurl) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.gameImageView.image = image
                        self.gameImageView.backgroundColor = .white
                    }
                }
            }
        }
    }
}

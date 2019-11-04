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
    @IBOutlet weak var gameContentView: UIView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageActivityIndicator.startAnimating()
    }
    
    var gameLanding: TopLevelDictionary.Game? {
        didSet {
            updateViews()
        }
    }
    
    var firebaseGameLanding: FirebaseGame? {
        didSet {
            updateViews1()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if gameContentView != nil {
            gameContentView.layer.borderWidth = 1.0
            gameContentView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            gameContentView.layer.shadowColor = #colorLiteral(red: 0, green: 0.4507690917, blue: 0.8604060914, alpha: 1)
            gameContentView.layer.shadowRadius = 4.0
            gameContentView.layer.shadowOpacity = 1.0
            gameContentView.layer.shadowOffset = CGSize(width:0, height: 2)
            gameContentView.layer.shadowPath = UIBezierPath(rect: gameContentView.bounds).cgPath
        }
    }
    
    func updateViews1() {
        guard let game = firebaseGameLanding else { return }
        nameLabel.text = game.gameName
        ratingLabel.text = "Game rating: \(game.averageRating?.rounded(toPlaces: 2) ?? 0)/5"
        descriptionLabel.text = GameController.shared.createNewDescription(game.description ?? "No Description Available")
        if let imageurl = game.imageURL {
            GameController.shared.fetchImageFor(gameImageURL: imageurl) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.gameImageView.image = image
                        self.gameImageView.backgroundColor = .white
                        self.imageActivityIndicator.stopAnimating()
                        self.imageActivityIndicator.isHidden = true
                    }
                }
            }
        }
    }
    
    func updateViews() {
        guard let game = gameLanding else { return }
        nameLabel.text = game.name
        ratingLabel.text = "\(game.average_user_rating?.rounded(toPlaces: 2) ?? 0) / 5"
        descriptionLabel.text = GameController.shared.createNewDescription(game.description ?? "No Description Available")
        if let imageurl = game.thumb_url {
            GameController.shared.fetchImageFor(gameImageURL: imageurl) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.gameImageView.image = image
                        self.gameImageView.backgroundColor = .white
                        self.imageActivityIndicator.stopAnimating()
                        self.imageActivityIndicator.isHidden = true
                    }
                }
            }
        }
    }
    
}

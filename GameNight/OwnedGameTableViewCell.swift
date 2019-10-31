//
//  OwnedGameTableViewCell.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/29/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class OwnedGameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameCellView: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    
    var firebaseGameLanding: FirebaseGame? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let game = firebaseGameLanding else { return }
        gameLabel.text = game.gameName
        if let imageurl = game.imageURL {
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if gameCellView != nil {
            gameCellView.layer.borderWidth = 1.0
            gameCellView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            gameCellView.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            gameCellView.layer.shadowRadius = 4.0
            gameCellView.layer.shadowOpacity = 1.0
            gameCellView.layer.shadowOffset = CGSize(width:0, height: 2)
            gameCellView.layer.shadowPath = UIBezierPath(rect: gameCellView.bounds).cgPath
        }
    }
    
}

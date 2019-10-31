//
//  WishListGameDetailViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/29/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class WishListGameDetailViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var ownGameButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var game: FirebaseGame? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownGameButton.layer.cornerRadius = ownGameButton.frame.height / 2
        removeButton.layer.cornerRadius = removeButton.frame.height / 2
        infoButton.layer.cornerRadius = infoButton.frame.height / 2
    }
    
    @IBAction func ownGameButtonTapped(_ sender: UIButton) {
        guard let gameID = game?.uuid, let userUUID = UserController.shared.currentUser?.uuid else { return }
        presentmoveToOwnedGamesAlert(gameId: gameID, userUUID: userUUID)
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        guard let gameID = game?.uuid, let userUUID = UserController.shared.currentUser?.uuid else { return }
        presentRemoveFromWishListAlert(gameId: gameID, userUUID: userUUID)
    }
    
    @IBAction func moreInfoButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moreInfoVC") as? MoreInfoViewController, let game = game else { return }
        destinationVC.firebaseGame = game
        self.present(destinationVC, animated: false)
    }
    
    func updateViews() {
        guard let game = game else { return }
        loadViewIfNeeded()
        nameLabel.text = game.gameName
        ratingLabel.text = "\(game.averageRating?.rounded(toPlaces: 2) ?? 0)/5"
        costLabel.text = game.msrp
        descriptionTextView.text = game.description
        if let imageURL = game.imageURL {
            GameController.shared.fetchImageFor(gameImageURL: imageURL) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.gameImageView.image = image
                    }
                }
            }
        }
    }
    
    func presentRemoveFromWishListAlert(gameId: String, userUUID: String) {
        let alert = UIAlertController(title: "Remove from Wishlist?", message: "If you no longer want this game, definitely remove it from your Wishlist!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (_) in
            FirebaseGameController.shared.removeFromWishList(with: userUUID, gameID: gameId) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true)
    }
    func presentmoveToOwnedGamesAlert(gameId: String, userUUID: String) {
        let alert = UIAlertController(title: "Move to Owned Games", message: "Did you finally buy that game you have been eyeing? Well congrats.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeFromWishListandAddToOwnedAction = UIAlertAction(title: "Remove and add to Owned Games?", style: .default) { (_) in
            FirebaseGameController.shared.removeFromWishList(with: userUUID, gameID: gameId) { (success) in
                if success {
                    FirebaseGameController.shared.addUserToOwnGameArray(userUUID: userUUID, gameID: gameId) { (success) in
                        if success {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(removeFromWishListandAddToOwnedAction)
        present(alert, animated: true)
    }
}

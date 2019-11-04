//
//  GameDetailViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ownGameButton: UIButton!
    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    var gameLanding: TopLevelDictionary.Game? {
        didSet {
            updateViews()
        }
    }
    
    var firebaseGameLanding: FirebaseGame? {
        didSet {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.isEditable = false
        ownGameButton.layer.cornerRadius = ownGameButton.frame.height / 2
        addToWishListButton.layer.cornerRadius = addToWishListButton.frame.height / 2
        moreInfoButton.layer.cornerRadius = moreInfoButton.frame.height / 2
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeHandled))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func rightSwipeHandled() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ownGameButtonTapped(_ sender: UIButton) {
        ownGameAlertController()
    }
    @IBAction func addToWishListButtonTapped(_ sender: UIButton) {
        addToWishListAlertController()
    }
    @IBAction func moreInfoButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moreInfoVC") as? MoreInfoViewController, let game = gameLanding else { return }
        destinationVC.gameLanding = game
        self.present(destinationVC, animated: false)
    }
    @IBAction func gameRulesButtonTapped(_ sender: UIBarButtonItem) {
        guard let game = gameLanding else { return }
        if game.rules_url != nil {
            guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "rulesWebVC") as? GameRulesViewController else { return }
            destinationVC.gameLanding = game
            destinationVC.modalPresentationStyle = .pageSheet
            present(destinationVC, animated: true)
        } else {
            noRulesURLAlert()
        }
    }
    
    func updateViews() {
        guard let game = gameLanding else { return }
        loadViewIfNeeded()
        imageActivityIndicator.startAnimating()
        nameLabel.text = game.name
        ratingLabel.text = "\((game.average_user_rating)?.rounded(toPlaces: 2) ?? 0)/5"
        descriptionTextView.text = GameController.shared.createNewDescription(game.description ?? "No Description Available")
        costLabel.text = "$" + (game.msrp ?? "N/A")
        if let imageURL = game.thumb_url {
            GameController.shared.fetchImageFor(gameImageURL: imageURL) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.gameImageView.image = image
                        self.imageActivityIndicator.stopAnimating()
                        self.imageActivityIndicator.hidesWhenStopped = true
                    }
                }
            }
        }
    }
}



extension GameDetailViewController {
    
    func addToWishListAlertController() {
        let alertController = UIAlertController(title: "Add to wishlist?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let game = self.gameLanding, let userUUID = UserController.shared.currentUser?.uuid else { return }
            FirebaseGameController.shared.checkToSeeIfGameExists(gameID: game.id) { (success) in
                if success {
                    FirebaseGameController.shared.addUserToWishListArray(userUUID: userUUID, gameID: game.id) { (success) in
                        if success {
                            print("SUCCESS ADDING TO WISH LIST")
                        }
                    }
                } else {
                    let firebaseGame = FirebaseGame(uuid: game.id, gameName: game.name, yearPublished: game.year_published, minPlayers: game.min_players, maxPlayers: game.max_players, minAge: game.min_age, minPlaytime: game.min_playtime, maxPlaytime: game.max_playtime, description: game.description, imageURL: game.thumb_url, msrp: game.msrp, averageRating: game.average_user_rating, rulesURL: game.rules_url, wishListUsers: [userUUID], ownUsers: [], gameImage: nil)
                    FirebaseGameController.shared.saveGame(game: firebaseGame) { (success) in
                        if success {
                            print("Success saving game to firebase")
                        }
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    func ownGameAlertController() {
        let alertController = UIAlertController(title: "Do you own this game?", message: "If you own this game and add it to your owned game list then you will be able to select this game for your next game night!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ownAction = UIAlertAction(title: "Yes, I own it", style: .default) { (_) in
            guard let game = self.gameLanding, let userUUID = UserController.shared.currentUser?.uuid else { return }
            
            FirebaseGameController.shared.checkToSeeIfGameExists(gameID: game.id) { (success) in
                if success {
                    FirebaseGameController.shared.addUserToOwnGameArray(userUUID: userUUID, gameID: game.id) { (success) in
                        if success {
                            print("USER ADDED TO GAME")
                        }
                    }
                } else {
                    let firebaseGame = FirebaseGame(uuid: game.id, gameName: game.name, yearPublished: game.year_published, minPlayers: game.min_players, maxPlayers: game.max_players, minAge: game.min_age, minPlaytime: game.min_playtime, maxPlaytime: game.max_playtime, description: game.description, imageURL: game.thumb_url, msrp: game.msrp, averageRating: game.average_user_rating, rulesURL: game.rules_url, wishListUsers: [], ownUsers: [userUUID], gameImage: nil)
                    FirebaseGameController.shared.saveGame(game: firebaseGame) { (success) in
                        if success {
                            print("Success saving game to firebase")
                        }
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(ownAction)
        present(alertController, animated: true)
    }
    
    func noRulesURLAlert() {
        let alertController = UIAlertController(title: "Sorry! Looks like this game does not have a rules URL", message: nil, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
}

//
//  OwnGameDetailViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/29/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class OwnGameDetailViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var dontOwnGameButton: UIButton!
    @IBOutlet weak var gameNotesButton: UIButton!
    @IBOutlet weak var gameNameLAbel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    var game: FirebaseGame? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageActivityIndicator.startAnimating()
        descriptionTextView.isEditable = false 
        dontOwnGameButton.layer.cornerRadius = dontOwnGameButton.frame.height / 2
        gameNotesButton.layer.cornerRadius = gameNotesButton.frame.height / 2
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeHandled))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func rightSwipeHandled() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreInfoButtonTapped(_ sender: UIBarButtonItem) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moreInfoVC") as? MoreInfoViewController, let game = game else { return }
        destinationVC.firebaseGame = game
        self.present(destinationVC, animated: false)
    }
    
    @IBAction func dontOwnGameButtonTapped(_ sender: UIButton) {
        guard let userUUID = UserController.shared.currentUser?.uuid, let gameId = game?.uuid else { return }
        presentDontOwnGameAlert(gameId: gameId, userUUID: userUUID)
    }
    
    @IBAction func gameNotesButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "notesVC") as? NotesTableViewController, let game = game else { return }
        destinationVC.gameID = game.uuid
        present(destinationVC, animated: true)
    }
    
    func updateViews() {
        guard let game = game else { return }
        loadViewIfNeeded()
        gameNameLAbel.text = game.gameName
        descriptionTextView.text = GameController.shared.createNewDescription(game.description ?? "No Description Available")
        if let image = game.gameImage {
            DispatchQueue.main.async {
                self.gameImageView.image = image
                self.imageActivityIndicator.stopAnimating()
                self.imageActivityIndicator.isHidden = true
            }
        } else {
            if let imageURL = game.imageURL {
                GameController.shared.fetchImageFor(gameImageURL: imageURL) { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.gameImageView.image = image
                            self.imageActivityIndicator.stopAnimating()
                            self.imageActivityIndicator.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func presentDontOwnGameAlert(gameId: String, userUUID: String) {
        let alert = UIAlertController(title: "Don't own the game?", message: "If you don't own this game we will remove it from your owned games.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (_) in
            FirebaseGameController.shared.removeOwnedGame(with: userUUID, gameID: gameId) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true)
    }
}

//
//  ChooseGameViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class ChooseGameViewController: UIViewController {
    
    @IBOutlet weak var numberOfPlayersMinStepper: UIStepper!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var playtimeMinStepper: UIStepper!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var minAgeStepper: UIStepper!
    @IBOutlet weak var minAgeLabel: UILabel!
    @IBOutlet weak var nameOfAppLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var chooseRandomButton: UIButton!
    @IBOutlet weak var seeListButton: UIButton!
    @IBOutlet weak var questionMarkLabel: UILabel!
    @IBOutlet weak var numberOfPlayersView: UIView!
    @IBOutlet weak var playtimeView: UIView!
    @IBOutlet weak var minAgeView: UIView!
    @IBOutlet weak var gameNameView: UIView!
    
    var numberOfPlayers: Int = 4
    var playtime: Int = 30
    var minAge: Int = 12
    
    var filteredGames: [FirebaseGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameImageView.layer.cornerRadius = 8
        chooseRandomButton.layer.cornerRadius = chooseRandomButton.frame.height / 2
        seeListButton.layer.cornerRadius = seeListButton.frame.height / 2
        numberOfPlayersView.layer.cornerRadius = 8
        playtimeView.layer.cornerRadius = 8
        minAgeView.layer.cornerRadius = 8
        gameNameView.layer.cornerRadius = 8
        minAgeStepper.maximumValue = 21
        minAgeStepper.value = 12
        numberOfPlayersMinStepper.value = 4
        numberOfPlayersMinStepper.maximumValue = 12
        numberOfPlayersMinStepper.minimumValue = 1
        let games = FirebaseGameController.shared.findRandomGame(numberOfPlayers: numberOfPlayers, playtime: playtime, minAge: minAge)
        self.filteredGames = games
        seeListButton.setTitle("See games (\(games.count))", for: .normal)
    }
    
    @IBAction func chooseRandomButtonTapped(_ sender: UIButton) {
        let games = FirebaseGameController.shared.findRandomGame(numberOfPlayers: numberOfPlayers, playtime: playtime, minAge: minAge)
        filteredGames = games
        seeListButton.setTitle("See games (\(games.count))", for: .normal)
        
        let randomGame = games.randomElement()
        if let game = randomGame {
            nameOfAppLabel.text = game.gameName
            if let imageURL = game.imageURL {
                GameController.shared.fetchImageFor(gameImageURL: imageURL) { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.questionMarkLabel.isHidden = true
                            self.gameImageView.image = image
                            self.gameImageView.backgroundColor = .white
                            let fadedAnimation = self.fadeAnimation(startingPoint: 0, endingPoint: 1, duration: 1.5)
                            self.gameImageView.layer.add(fadedAnimation, forKey: "opacity")
                            self.gameImageView.layer.opacity = 1
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.questionMarkLabel.isHidden = false
                self.gameImageView.image = nil
                self.gameImageView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
    }
    @IBAction func seeListOfGamesButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "filteredGameTVC") as? FilteredGameListTableViewController,
            filteredGames.count > 0
            else { presentNoGamesAlert();  return }
        destinationVC.games = filteredGames
        present(destinationVC, animated: true)
    }
    @IBAction func numberOfPlayersMinStepperTapped(_ sender: UIStepper) {
        numberOfPlayersLabel.text = "\(Int(sender.value))"
        numberOfPlayers = Int(sender.value)
        let games = FirebaseGameController.shared.findRandomGame(numberOfPlayers: numberOfPlayers, playtime: playtime, minAge: minAge)
        self.filteredGames = games
        seeListButton.setTitle("See games (\(games.count))", for: .normal)
    }
    @IBAction func playtimeMinStepperTapped(_ sender: UIStepper) {
        playtimeLabel.text = "\(Int(sender.value))"
        playtime = Int(sender.value)
        let games = FirebaseGameController.shared.findRandomGame(numberOfPlayers: numberOfPlayers, playtime: playtime, minAge: minAge)
        self.filteredGames = games
        seeListButton.setTitle("See games (\(games.count))", for: .normal)
    }
    @IBAction func minAgeStepperTapped(_ sender: UIStepper) {
        if sender.value == 21 {
            minAgeLabel.text = "\(Int(sender.value))+"
        } else {
            minAgeLabel.text = "\(Int(sender.value))"
        }
        minAge = Int(sender.value)
        let games = FirebaseGameController.shared.findRandomGame(numberOfPlayers: numberOfPlayers, playtime: playtime, minAge: minAge)
        self.filteredGames = games
        seeListButton.setTitle("See games (\(games.count))", for: .normal)
    }
    
    func presentNoGamesAlert() {
        let alert = UIAlertController(title: "No games...?", message: "Based on your filter preferences you have no games that match that criteria. Try to switch preferences!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
}

//Animations
extension ChooseGameViewController {
    func scaleAnimation(startingScale: CGFloat, endingScale: CGFloat, animationDuration: Double) -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = startingScale
        scaleAnimation.toValue = endingScale
        scaleAnimation.duration = animationDuration
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = 2
        return scaleAnimation
    }
    func fadeAnimation(startingPoint: CGFloat, endingPoint: CGFloat, duration: Double) -> CABasicAnimation {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = startingPoint
        fadeAnimation.toValue = endingPoint
        fadeAnimation.duration = duration
        return fadeAnimation
    }
}

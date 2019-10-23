//
//  HomeTableViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var topGameLabel: UILabel!
    @IBOutlet weak var topGameImageView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "gameCell")
        
        GameController.shared.fetchMostPopularGames { (success) in
            if success {
                self.setupViews()
            }
        }
    }
    
    @IBAction func topGameButtonTapped(_ sender: UIButton) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailVC") as? GameDetailViewController else { return }
        let game = GameController.shared.mostPopularGames[0]
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.gameLanding = game
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupViews() {
        guard let firstGame = GameController.shared.mostPopularGames.first else { return }
        DispatchQueue.main.async {
            self.imageActivityIndicator.startAnimating()
            GameController.shared.fetchImageFor(gameImageURL: firstGame.thumb_url!) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.topGameLabel.text = "Top trending game: " + firstGame.name
                        self.topGameImageView.backgroundColor = .white
                        self.topGameImageView.image = image
                        self.imageActivityIndicator.stopAnimating()
                        self.imageActivityIndicator.hidesWhenStopped = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.mostPopularGames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height / 9
        return height 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailVC") as? GameDetailViewController else { return }
        let game = GameController.shared.mostPopularGames[indexPath.row]
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.gameLanding = game
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        let game = GameController.shared.mostPopularGames[indexPath.row]
        cell.gameLanding = game
        return cell
    }
}

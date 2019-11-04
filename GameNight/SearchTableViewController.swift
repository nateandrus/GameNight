//
//  MainGameTableViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    @IBOutlet var searchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchLabel: UILabel!
    @IBOutlet weak var gameSearchBar: UISearchBar!
    
    var games: [TopLevelDictionary.Game] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let y = Double(self.view.frame.height / 2) - 150
        let width = Double(self.view.frame.width) - 32
        let height = 50.0
        searchLabel.frame = CGRect(x: 16, y: y, width: width, height: height)
        self.view.addSubview(searchLabel)
        self.view.addSubview(searchActivityIndicator)
        constrainActivityIndicator()
        searchActivityIndicator.isHidden = true
        gameSearchBar.becomeFirstResponder()
        gameSearchBar.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "gameCell")
    }
    
    func constrainActivityIndicator() {
        searchActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: searchActivityIndicator!, attribute: .top, relatedBy: .equal, toItem: self.searchLabel, attribute: .top, multiplier: 1, constant: 48),
            NSLayoutConstraint(item: searchActivityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)])
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height / 9
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailVC") as? GameDetailViewController else { return }
        let game = games[indexPath.row]
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.gameLanding = game
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell

        let game = games[indexPath.row]
        cell.gameLanding = game
        
        return cell
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchActivityIndicator.isHidden = false
        self.searchActivityIndicator.startAnimating()
        searchBar.resignFirstResponder()
        GameController.shared.fetchGames(searchTerm: text) { (games) in
            if let searchGames = games {
                if searchGames.count > 0 {
                    self.games = searchGames
                    DispatchQueue.main.async {
                        self.searchActivityIndicator.stopAnimating()
                        self.searchActivityIndicator.isHidden = true
                        self.searchLabel.isHidden = true
                        self.tableView.reloadData()
                    }
                } else {
                    self.games = searchGames
                    DispatchQueue.main.async {
                        self.searchActivityIndicator.stopAnimating()
                        self.searchActivityIndicator.isHidden = true
                        self.tableView.reloadData()
                        self.searchLabel.isHidden = false
                        self.searchLabel.text = "No results, try a different search term!"
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search cancelled")
    }
}

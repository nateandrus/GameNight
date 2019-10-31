//
//  MainGameTableViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var gameSearchBar: UISearchBar!
    
    var games: [TopLevelDictionary.Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSearchBar.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "gameCell")
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
        searchBar.resignFirstResponder()
        GameController.shared.fetchGames(searchTerm: text) { (games) in
            if let games = games {
                self.games = games
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

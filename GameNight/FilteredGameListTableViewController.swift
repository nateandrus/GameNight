//
//  FilteredGameListTableViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class FilteredGameListTableViewController: UITableViewController {
    
    var games: [FirebaseGame] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "OwnedGameTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "filteredGameCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height / 8
        return height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filteredGameCell", for: indexPath) as! OwnedGameTableViewCell

        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view 
        let game = games[indexPath.row]
        cell.firebaseGameLanding = game

        return cell
    }
}

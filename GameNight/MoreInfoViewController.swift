//
//  MoreInfoViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var moreInfoForGameLabel: UILabel!
    @IBOutlet weak var yearPublishedLabel: UILabel!
    @IBOutlet weak var minPlayerLabel: UILabel!
    @IBOutlet weak var maxPlayerLabel: UILabel!
    @IBOutlet weak var minPlaytimeLabel: UILabel!
    @IBOutlet weak var maxPlaytimeLabel: UILabel!
    @IBOutlet weak var minAgeLabel: UILabel!
    
    var gameLanding: TopLevelDictionary.Game? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        moreInfoView.layer.cornerRadius = 8
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        guard let game = gameLanding else { return }
        loadViewIfNeeded()
        moreInfoForGameLabel.text = "More info for: \(game.name)"
        if let year = game.year_published {
            yearPublishedLabel.text = "\(year)"
        } else {
            yearPublishedLabel.text = "N/A"
        }
        if let minPlayer = game.min_players {
            minPlayerLabel.text = "\(minPlayer) players"
        } else {
            minPlayerLabel.text = "N/A"
        }
        if let maxPlayer = game.max_players {
            maxPlayerLabel.text = "\(maxPlayer) players"
        } else {
            maxPlayerLabel.text = "N/A"
        }
        if let minPlaytime = game.min_playtime {
            minPlaytimeLabel.text = "\(minPlaytime) min."
        } else {
            minPlaytimeLabel.text = "N/A"
        }
        if let maxPlaytime = game.max_playtime {
            maxPlaytimeLabel.text = "\(maxPlaytime) min."
        } else {
            maxPlaytimeLabel.text = "N/A"
        }
        if let minAge = game.min_age {
            minAgeLabel.text = "\(minAge)"
        } else {
            minAgeLabel.text = "N/A"
        }
    }
    
    
}

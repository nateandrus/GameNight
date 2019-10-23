//
//  GameRulesViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import WebKit

class GameRulesViewController: UIViewController {

    @IBOutlet weak var rulesWebView: WKWebView!
    
    var gameLanding: TopLevelDictionary.Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipedown.direction = .down
        view.addGestureRecognizer(swipedown)
        
        if let rulesURL = gameLanding?.rules_url {
            if let url = URL(string: rulesURL) {
                let request = URLRequest(url: url)
                rulesWebView.load(request)
            } else {
                print("Not a url")
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

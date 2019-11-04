//
//  GameRulesViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import WebKit

class GameRulesViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var rulesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var rulesWebView: WKWebView!
    
    var gameLanding: TopLevelDictionary.Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesWebView.uiDelegate = self
        rulesActivityIndicator.startAnimating()
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipedown.direction = .down
        view.addGestureRecognizer(swipedown)
        
        if let rulesURL = gameLanding?.rules_url {
            if let url = URL(string: rulesURL) {
                let request = URLRequest(url: url)
                rulesWebView.load(request)
                
                if rulesWebView.isLoading {
                    rulesActivityIndicator.stopAnimating()
                    rulesActivityIndicator.isHidden = true
                } else {
                    couldntFindURLAlert()
                }
                
            } else {
                print("Not a url")
                dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
   
    
    func couldntFindURLAlert() {
        let alert = UIAlertController(title: "Couldn't find rules URL.", message: "Sorry about that...", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
        
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SplashScreenViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        findUser()
    }
    
    func findUser() {
        if Auth.auth().currentUser != nil {
            if let userUUID = Auth.auth().currentUser?.uid {
                UserController.shared.loadUser(firebaseUID: userUUID) { (user) in
                    if user != nil {
                        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTab")
                        destinationVC.modalPresentationStyle = .fullScreen
                        self.present(destinationVC, animated: true)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            }
        }
    }
}

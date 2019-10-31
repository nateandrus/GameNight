//
//  CreateUsernameViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/24/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit
import Firebase

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var goTimeButton: UIButton!
    
    var uuidLanding: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goTimeButton.layer.cornerRadius = goTimeButton.frame.height / 2
    }
    
    
    @IBAction func goTimeButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty, uuidLanding != nil, email != nil else { return }
        
        let user = User(username: username, email: email!, uuid: uuidLanding!, profileImageURL: uuidLanding!, profileImage: nil)
        
        UserController.shared.createGameNightUser(user: user) { (success) in
            if success {
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTab")
                destinationVC.modalPresentationStyle = .fullScreen
                self.present(destinationVC, animated: true)
            }
        }
    }
}

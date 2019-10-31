//
//  LoginViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/24/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginSegmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            createAccountButton.setTitle("Ceate Account", for: .normal)
        } else {
            createAccountButton.setTitle("Login", for: .normal)
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if loginSegmentedController.selectedSegmentIndex == 0 {
            UserController.shared.createFirebaseUser(email: emailTextField.text!, password: passwordTextField.text!) { (uuid, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorAlertController(error: error.localizedDescription)
                }
                if let uuid = uuid {
                    guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "createUsernameVC") as? CreateUsernameViewController else { return }
                    destinationVC.uuidLanding = uuid
                    destinationVC.email = self.emailTextField.text!
                    self.present(destinationVC, animated: true)
                }
            }
        } else {
            UserController.shared.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (uuid, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorAlertController(error: error.localizedDescription)
                }
                if let uuid = uuid {
                    UserController.shared.loadUser(firebaseUID: uuid) { (user) in
                        if user != nil {
                            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTab")
                            destinationVC.modalPresentationStyle = .fullScreen
                            self.present(destinationVC, animated: true)
                            FirebaseGameController.shared.fetchUsersWishListGames(userUUID: uuid) { (success) in
                                if success {
                                }
                            }
                            FirebaseGameController.shared.fetchUsersOwnedGames(userUUID: uuid) { (success) in
                                if success {
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func errorAlertController(error: String) {
        let alertController = UIAlertController(title: "Error logging in.", message: error, preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(cancelAlert)
        present(alertController, animated: true)
    }
}

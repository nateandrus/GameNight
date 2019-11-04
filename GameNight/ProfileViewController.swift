//
//  ProfileViewController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/23/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var gamesSegmentController: UISegmentedControl!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var setImageButton: UIButton!
    
    var selectedImage: UIImage? {
        didSet {
            guard let userUUID = UserController.shared.currentUser?.uuid, let image = self.selectedImage else { return }
            self.profileImageActivityIndicator.startAnimating()
            UserController.shared.updateProfileImageFor(userID: userUUID, usingImage: image) { (success) in
                if success {
                    self.setImageButton.setTitle("", for: .normal)
                    self.profileImage.image = self.selectedImage
                    self.profileImageActivityIndicator.stopAnimating()
                    self.profileImageActivityIndicator.isHidden = true
                } else {
                    self.setImageButton.setTitle("Set Image", for: .normal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTableView.delegate = self
        gameTableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        gameTableView.register(nib, forCellReuseIdentifier: "gameCell")
        let nib1 = UINib(nibName: "OwnedGameTableViewCell", bundle: nil)
        gameTableView.register(nib1, forCellReuseIdentifier: "ownedGameCell")
        if let userUUID = UserController.shared.currentUser?.uuid {
            profileImageActivityIndicator.startAnimating()
            UserController.shared.loadProfileImageForUser(withUUID: userUUID) { (image) in
                if let image = image {
                    self.setImageButton.setTitle("", for: .normal)
                    self.profileImage.image = image
                    self.profileImageActivityIndicator.stopAnimating()
                    self.profileImageActivityIndicator.isHidden = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = UserController.shared.currentUser else { return }
        usernameLabel.text = user.username
        FirebaseGameController.shared.fetchUsersWishListGames(userUUID: user.uuid) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.gameTableView.reloadData()
                }
            }
        }
        FirebaseGameController.shared.fetchUsersOwnedGames(userUUID: user.uuid) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.gameTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        gameTableView.reloadData()
    }
    @IBAction func setImageButtonTapped(_ sender: UIButton) {
        presentImagePickerActionSheet()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gamesSegmentController.selectedSegmentIndex == 0 {
            return FirebaseGameController.shared.usersOwnGames.count
        } else {
            return FirebaseGameController.shared.usersWishListGames.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height / 9
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if gamesSegmentController.selectedSegmentIndex == 0 {
            guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ownGameDetailVC") as? OwnGameDetailViewController else { return }
            let game = FirebaseGameController.shared.usersOwnGames[indexPath.row]
            destinationVC.modalPresentationStyle = .fullScreen
            destinationVC.game = game
            navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "wishListDetailVC") as? WishListGameDetailViewController else { return }
            let game = FirebaseGameController.shared.usersWishListGames[indexPath.row]
            destinationVC.modalPresentationStyle = .fullScreen
            destinationVC.game = game
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gamesSegmentController.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ownedGameCell", for: indexPath) as! OwnedGameTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            let game = FirebaseGameController.shared.usersOwnGames[indexPath.row]
            cell.firebaseGameLanding = game
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            let game = FirebaseGameController.shared.usersWishListGames[indexPath.row]
            cell.firebaseGameLanding = game
            return cell
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = photo
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let actionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

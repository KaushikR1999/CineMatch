//
//  ProfileViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit
import Firebase
import Kingfisher


class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var regionTextField: UITextField!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    var regionPickerView = UIPickerView()
    var currentUsername: String?
    let regionToolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
        
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.bounds.width/2.0
        profilePicture.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        )
        
        userNameTextField.delegate = self
        
        regionToolBar.barStyle = .default
        regionToolBar.isTranslucent = true
        regionToolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelTapped))

        regionToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        regionToolBar.isUserInteractionEnabled = true
        
        regionPickerView.delegate = self
        regionPickerView.dataSource = self
        
        
        regionTextField.delegate = self
        regionTextField.inputView = regionPickerView
        regionTextField.inputAccessoryView = regionToolBar
        
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!
            DatabaseManager.shared.loadProfilePage(with: user.uid) { (data) in
                DispatchQueue.main.async {
                    
                    self.regionTextField.text = data["region"] as? String
                    
                    self.userNameTextField.text = data["username"] as? String
                    self.currentUsername = data["username"] as? String
                    
                    self.emailAddressLabel.text = Auth.auth().currentUser?.email
                    
                    
                    if let profilePictureURLString = data["profilePictureURL"] as? String {
                        if let profilePictureURL = URL(string: profilePictureURLString) {
                            self.profilePicture.kf.setImage(with: profilePictureURL)
                        }
                    }
                }
            }
        }
        
        
 
    }
                        
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        AuthManager.shared.logoutUser { (success) in
            DispatchQueue.main.async {
                if success {
                    let navVC = self.storyboard?.instantiateViewController(identifier: "NavigationLoginController") as!
                    UINavigationController
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
        }
        print("LOGGED OUT")
    }
    
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
}



//MARK: - ImagePicker methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentCamera()
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentPhotoPicker()
                                            }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        profilePicture.image = selectedImage
 
        StorageManager.shared.uploadProfilePicture(with: imageData)
                
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}

//MARK: - PickerView methods



extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc func cancelTapped() {
        regionTextField.resignFirstResponder()
    }
    
    @objc func doneTapped() {
        let row = regionPickerView.selectedRow(inComponent: 0)
        let selectedCountry = Locale.getCountries()[row]
        DatabaseManager.shared.updateUserRegion(with: selectedCountry) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.regionTextField.text = selectedCountry
                }
            }
            self.regionTextField.resignFirstResponder()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Locale.getCountries().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Locale.getCountries()[row]
    }
    
    
}

//MARK: - TextField methods
extension ProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == regionTextField {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            if Auth.auth().currentUser != nil {
                let newUsername = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                if newUsername.isEmpty {
                    DispatchQueue.main.async {
                        let message = "Username cannot be empty"
                        let alert = UIAlertController(title: "Username error", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        textField.text = self.currentUsername
                    }
                }
                
                else {
                    DatabaseManager.shared.checkIfUsernameAvailable(with: newUsername) { available in
                        if available {
                            DatabaseManager.shared.updateUsername(with: newUsername) { success in
                                if success {
                                    DispatchQueue.main.async {
                                        textField.text = newUsername
                                    }
                                }
                                
                            }
                        }
                        
                        else {
                            if self.currentUsername != textField.text! {
                                DispatchQueue.main.async {
                                    let message = "Please choose a different username"
                                    let alert = UIAlertController(title: "Username taken", message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    textField.text = self.currentUsername
                                }
                            }
                            
                            
                        }
                        
                    }
                }
                

            }
        }
        

        
        textField.resignFirstResponder()
        return true
    }
    

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField == userNameTextField {
            return textFieldShouldReturn(userNameTextField)
        }
        
        if textField == regionTextField {
            return textFieldShouldReturn(regionTextField)
        }
        
        return false
        
    }
    
   
    

    
}

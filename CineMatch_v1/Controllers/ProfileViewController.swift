import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var profilePicture: UIImageView!

    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var regionTextField: UITextField!
    
    var regionPickerView = UIPickerView()
    
    var countryManager = CountryManager()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Profile Picture
        
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.bounds.width/2.0
        
        profilePicture.isUserInteractionEnabled = true
        
        // tapping on profile picture region will bring up action sheet
        profilePicture.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        )
        
        
        // Picker View
        regionPickerView.dataSource = self
        regionPickerView.delegate = self
        
        
        // Text Field
        regionTextField.delegate = self
        
        // tapping on text field will bring up the picker view
        regionTextField.inputView = regionPickerView
        
        userName.delegate = self
        
        // Display User's Email in userEmail Label
        userEmail.text = Auth.auth().currentUser?.email
        
        // Retrieve User's Username and region from User Details collection & display it in userName TextField
        let users = db.collection("User Details").document(Auth.auth().currentUser!.uid)
        users.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userName.text = document.data()!["Username"] as? String
                self.regionTextField.text = document.data()!["Region"] as? String
            } else {
                print("Document does not exist")
            }
        }
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == regionTextField {
            return false
        }
        return true
    }
    
    // Function to allow User to modify username. User has to press enter for change to be updated
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Auth.auth().currentUser != nil {
            self.db.collection("User Details").document(Auth.auth().currentUser!.uid).updateData([
                "Username": textField.text!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    // print("Document successfully updated")
                }
            }
        }
        return true
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryManager.getCountries().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryManager.getCountries()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countryManager.getCountries()[row]
        
        // updates country in text field to selected country
        regionTextField.text = selectedCountry
        
        // Update region in Firebase User Details to selected country
        if Auth.auth().currentUser != nil {
            self.db.collection("User Details").document(Auth.auth().currentUser!.uid).updateData([
                "Region": selectedCountry
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    // print("Document successfully updated")
                }
            }
        }
    }
    
}

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
        
        self.profilePicture.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}







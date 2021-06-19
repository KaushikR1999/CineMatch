import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var regionTextField: UITextField!
    
    var regionPickerView = UIPickerView()
    
    var countryManager = CountryManager()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionPickerView.dataSource = self
        regionPickerView.delegate = self
        
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






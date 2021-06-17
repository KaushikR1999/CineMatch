import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        
        // Display User's Email in userEmail Label
        userEmail.text = Auth.auth().currentUser?.email
        
        // Retrieve User's Username from User Details collection & display it in userName TextField
        let users = db.collection("User Details").document(Auth.auth().currentUser!.uid)
        users.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userName.text = document.data()!["Username"] as? String
            } else {
                print("Document does not exist")
            }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

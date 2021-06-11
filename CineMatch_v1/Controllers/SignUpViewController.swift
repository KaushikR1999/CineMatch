import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print (e.localizedDescription)
                } else {
                    
                    // Save Username
                    self.db.collection("personal details").addDocument(data: [
                        "Username": username,
                        "UID": Auth.auth().currentUser?.uid
                    ])
                    
                    // Navigate to the HomeViewController
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                }
            }
        }
    }
}

import UIKit
import Firebase
import PasswordTextField

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.autocorrectionType = .no

        // Do any additional setup after loading the view.
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        // clears the TextFields when User comes to page
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        
        // Check if username is available, else continue on to check if email/password valid
        
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.db.collection("Usernames").document(username!).getDocument { (document, error) in
            if let document = document, document.exists {
                let message = "Please choose a different username"
                let alert = UIAlertController(title: "Username taken", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let email = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let password = self.passwordTextField.text?.trimmingCharacters(in: .whitespaces) {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            
                            // Pop up alert in case of invalid entry
                            
                            let alert = UIAlertController(title: "Invalid Email/Password!", message: e.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            /*Save Username and default region as United States in User Details Collection
                             Save profileImageURL which will be used to retrieve profile pic as empty first
                             */
                            self.db.collection("User Details").document(Auth.auth().currentUser!.uid).setData(["Username": username!, "Region": "United States", "profileImageURL": ""])
                            
                            // Save Username to Username collection to keep track of usernames used
                            self.db.collection("Usernames").document(username!).setData([:])
                            
                            // Navigate to the HomeViewController
                            
                            self.performSegue(withIdentifier: "signUpToHome", sender: self)
                            self.view.endEditing(true)
                        }
                    }
                }
            }
        }
    }
}

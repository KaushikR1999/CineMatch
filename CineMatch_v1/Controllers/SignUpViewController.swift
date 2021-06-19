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
        
        if let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {

                    // Pop up alert in case of invalid entry
                    
                    let alert = UIAlertController(title: "Invalid Email/Password!", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    // Save Username and default region as United States in User Details Collection
                    self.db.collection("User Details").document(Auth.auth().currentUser!.uid).setData(["Username": username, "Region": "United States"])
                    
                    
                    // Navigate to the HomeViewController
                    
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    self.view.endEditing(true)
                }
            }
        }
    }
}

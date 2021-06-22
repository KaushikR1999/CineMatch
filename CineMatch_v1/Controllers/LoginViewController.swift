import UIKit
import Firebase
import PasswordTextField

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        
        // checks if there is a user logged in, if so don't need to present log out page
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // clears the TextFields when User comes to page
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Function to lead from Login Page to Home Page if user input valid entry
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginUser(email, password)
        }
    }
    
    // handles logging in user logic
    func loginUser(_ email: String, _ password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                
                // Pop up alert in case of invalid entry
                
                let alert = UIAlertController(title: "Invalid Email/Password!", message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                // Segue from screen to screen & not button to screen as segueing from button will override this function and go to Home Page even if user has input invalid entry
                
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                self.view.endEditing(true)
            }
        }
        
        
    }

    // Function to lead from Login page to Sign up Page for new User
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSignUp", sender: self)
    }
}

import UIKit
import Firebase
import PasswordTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Initialise Firestore database
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.autocorrectionType = .no
        
        // if user taps anywhere outside the keyboard, the keyboard is dismissed from view
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        // clears the text fields before the user comes to the sign up page if user exits page
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        // If username, email and password are not empty, then continue to creating user
        
        if let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let email = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let password = self.passwordTextField.text?.trimmingCharacters(in: .whitespaces) {
            createUser(username, email, password)
        }
    }
    
    // handles creating user logic
    func createUser(_ username: String, _ email: String, _ password: String) {
        
        db.collection("Usernames").document(username).getDocument { (document, error) in
            
            // if username already exists, present error to user
            if let document = document, document.exists {
                let message = "Please choose a different username"
                let alert = UIAlertController(title: "Username taken", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            else {
            
                // if email address already exists, present error to user
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        let alert = UIAlertController(title: "Invalid Email/Password!", message: e.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        /*Save Username and default region as United States in User Details Collection
                         Save profileImageURL which will be used to retrieve profile pic as empty first
                         */
                        
                        /* Creates and stores user and their information in User Details Collection
                         using key-value pairs.
                         
                         Default region is set as United States, user can change later
                         Default profileImageURL (url for where the profile image is stored) initially empty
                         */
                        
                        self.db.collection("User Details").document(Auth.auth().currentUser!.uid).setData(
                            ["Username": username,
                             "Region": "United States",
                             "profileImageURL": "",
                             "Friends": [String](),
                             "FriendRequestsSent": [String](),
                             "FriendRequestsReceived": [String]()
                            ]
                        )
                        
                        /* Save user's username to a Username collection to keep track of all usernames
                        in the app */
                        
                        self.db.collection("Usernames").document(username).setData([:])
                        
                        // Navigate to the HomeViewController
                        
                        self.performSegue(withIdentifier: "signUpToHome", sender: self)
                        self.view.endEditing(true)
                    }
                }
            }
        }
    }

}


//
//  LoginViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit
import Firebase 

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signUpHereButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        handleAuthenticated()
        
        emailAddressTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailAddressTextField.tag = 1
        passwordTextField.tag = 2
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        
        
    }
    
    private func handleAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        
    
    }
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        guard let email = emailAddressTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            presentAlert()
            return
        }
        
        AuthManager.shared.loginUser(email: email, password: password) { success in
            DispatchQueue.main.async {
                
                if success {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
                else {
                    self.presentAlert()
                }
                
            }

        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(
            title: "Log In Error",
            message: "Incorrect email address and/or password",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil))
        
        self.present(alert, animated: true)
    }
    

   
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
}

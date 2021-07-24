//
//  RegistrationViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        
        userNameTextField.text = ""
        emailAddressTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        

        userNameTextField.tag = 1
        emailAddressTextField.tag = 2
        passwordTextField.tag = 3
        
        userNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        guard let username = userNameTextField.text, !username.isEmpty,
              let email = emailAddressTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            presentAlert()
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { (registered) in
            if registered {
                self.performSegue(withIdentifier: "registerToHome", sender: self)
            } else {
                DispatchQueue.main.async {
                    self.presentAlert()
                }
            }
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(
            title: "Sign up error",
            message: "Invalid username, email address and/or password",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
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

//
//  ViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSignUp", sender: self)
    }
}


//
//  PastSessionsViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class PastSessionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pastSessionsToHome", sender: self)
    }
    
    @IBAction func sessionPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psToPSI", sender: self)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pastSessionsToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pastSessionsToSearch", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pastSessionsToProfile", sender: self)
    }
}

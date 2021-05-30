//
//  HomeViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToSearch", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToProfile", sender: self)
    }
    
    @IBAction func restorePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeToPastSessions", sender: self)
    }
}

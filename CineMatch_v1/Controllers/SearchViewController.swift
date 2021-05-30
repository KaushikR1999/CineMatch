//
//  SearchViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchToHome", sender: self)
    }
    
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchToProfile", sender: self)
    }
    
}

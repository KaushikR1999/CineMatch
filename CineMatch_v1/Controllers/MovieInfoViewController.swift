//
//  MovieInfoViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class MovieInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieInfoToPastSessionsInfo", sender: self)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieInfoToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieInfoToSearch", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieInfoToProfile", sender: self)
    }
}

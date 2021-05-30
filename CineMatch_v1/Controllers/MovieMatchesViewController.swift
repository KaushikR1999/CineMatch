//
//  MovieMatchesViewController.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 28/5/21.
//

import UIKit

class MovieMatchesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieMatchesToMovieSwipe", sender: self)
    }
    
    
    @IBAction func moviePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieMatchesToMovieInfo", sender: self)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieMatchesToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieMatchesToSearch", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieMatchesToProfile", sender: self)
    }
}

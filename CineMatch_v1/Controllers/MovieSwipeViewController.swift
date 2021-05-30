import UIKit

class MovieSwipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func matchesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieSwipeToMovieMatches", sender: self)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieSwipeToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieSwipeToSearch", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieSwipeToProfile", sender: self)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "movieSwipeToPSI", sender: self)
    }
}

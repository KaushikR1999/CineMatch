import UIKit

class PastSessionsInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moviePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToMovieInfo", sender: self)
    }
        
    @IBAction func rejoinPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToMovieSwipe", sender: self)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToSearch", sender: self)
    }
    
    
    @IBAction func profilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToProfile", sender: self)
    }
}

import UIKit

class PastSessionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

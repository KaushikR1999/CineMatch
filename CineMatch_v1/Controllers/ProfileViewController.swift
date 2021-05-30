import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profileToHome", sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profileToSearch", sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logOut", sender: self)
    }
}

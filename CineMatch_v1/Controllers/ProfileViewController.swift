import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            print ("Logging out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
//        self.performSegue(withIdentifier: "logOut", sender: self)
    }
    
}

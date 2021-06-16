import UIKit

class PastSessionsInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moviePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "psiToMovieInfo", sender: self)
    }
    
}

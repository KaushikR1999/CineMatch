import UIKit

class MovieSwipeViewController: UIViewController {

    var friends: [Friend] = [
        Friend(friendName: "Mary Jane", friendImage: #imageLiteral(resourceName: "Mary Jane")),
        Friend(friendName: "Harry Osborn", friendImage: #imageLiteral(resourceName: "Harry Osborn")),
        Friend(friendName: "Gwen Stacy", friendImage: #imageLiteral(resourceName: "Gwen Stacy"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}

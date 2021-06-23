import UIKit

class MovieSwipeViewController: UIViewController {

    var friends: [SearchUser] = [
        SearchUser(searchUserName: "Mary Jane", searchUserImage: #imageLiteral(resourceName: "Mary Jane")),
        SearchUser(searchUserName: "Harry Osborn", searchUserImage: #imageLiteral(resourceName: "Harry Osborn")),
        SearchUser(searchUserName: "Gwen Stacy", searchUserImage: #imageLiteral(resourceName: "Gwen Stacy"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}

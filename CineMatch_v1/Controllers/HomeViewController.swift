import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [Friend] = [
        Friend(friendName: "Mary Jane", friendImage: #imageLiteral(resourceName: "Mary Jane")),
        Friend(friendName: "Harry Osborn", friendImage: #imageLiteral(resourceName: "Harry Osborn")),
        Friend(friendName: "Gwen Stacy", friendImage: #imageLiteral(resourceName: "Gwen Stacy"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendSessionCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! FriendSessionCell
        cell.friendName.text = friends[indexPath.row].friendName
        cell.friendImage.image = friends[indexPath.row].friendImage
        return cell
    }
    
}

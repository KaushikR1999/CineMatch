import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [SearchUser] = [
        SearchUser(searchUserName: "Mary Jane", searchUserImage: #imageLiteral(resourceName: "Mary Jane")),
        SearchUser(searchUserName: "Harry Osborn", searchUserImage: #imageLiteral(resourceName: "Harry Osborn")),
        SearchUser(searchUserName: "Gwen Stacy", searchUserImage: #imageLiteral(resourceName: "Gwen Stacy"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendSessionCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
}

// MARK: - TableView DataSource Methods

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! FriendSessionCell
        cell.friendName.text = friends[indexPath.row].searchUserName
        cell.friendImage.image = friends[indexPath.row].searchUserImage
        return cell
    }
    
}

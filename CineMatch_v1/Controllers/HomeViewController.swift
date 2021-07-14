import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendRequestsIcon: UIBarButtonItem!
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    var friends: [SearchUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        // loadTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: NSNotification.Name(rawValue: "load"), object: nil)
        loadTable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // self.friends.removeAll()
    }
    
    @objc func loadTable() {
        
        // friends.removeAll()
        databaseManager.getFriendRequests(callback: { (friendRequestsReceived) in
            
            if friendRequestsReceived.count > 0 {
                self.friendRequestsIcon.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
            } else {
                
                self.friendRequestsIcon.image = UIImage(systemName: "person.2.fill")
            }
        })
        
        let userDetails = db.collection("User Details")
        DispatchQueue.global().async {
            self.databaseManager.getFriends(callback: { (friendArray) in
                self.friends.removeAll()
                var x = 0
                for friend in friendArray {
                    /* let listener = */ userDetails.document(friend)
                        .addSnapshotListener /* (includeMetadataChanges: true) */ { documentSnapshot, error in
                            guard let document = documentSnapshot else {
                                print("Error fetching document: \(error!)")
                                return
                            }
                            guard let data = document.data() else {
                                print("Document data was empty.")
                                return
                            }
                            print (x)
                            x = x+1
                            let profileURLString = data["profileImageURL"] as? String
                            self.friends.append(SearchUser(
                                                    searchUserName: (data["Username"] as? String)!,
                                                    searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                    searchUserUID: document.documentID))
                            self.friends = self.friends.sorted(by: { $0.searchUserName < $1.searchUserName })
                            print (self.friends.count)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                }
            }
            )
        }

        tableView.register(UINib(nibName: "FriendSessionCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
}

// MARK: - TableView DataSource Methods

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchUserSessionCell
        cell.searchUserName.text = friends[indexPath.row].searchUserName
        cell.searchUserImage.image = friends[indexPath.row].searchUserImage
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            databaseManager.deleteFriend(friends[indexPath.row].searchUserUID)
            DispatchQueue.main.async {
                tableView.beginUpdates()
                self.friends.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                self.loadTable()
            }
        }
    }
    
}

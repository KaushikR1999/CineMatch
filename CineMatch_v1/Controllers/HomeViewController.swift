import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    var friends: [SearchUser] = []
    
    override func viewDidLoad() {
        // super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        print ("Yes")
        
        var friendsUID: [String] = []
        friends = []
        let userDetails = db.collection("User Details")
        userDetails.document(Auth.auth().currentUser!.uid)
            .addSnapshotListener (includeMetadataChanges: true) { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                friendsUID = document.data()!["Friends"] as! [String]
                print ("Before \(friendsUID.count)")
                print ("Before \(self.friends.count)")
                for friendUID in friendsUID {
                    
                    userDetails.document(friendUID).addSnapshotListener () { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        let profileURLString = document.data()?["profileImageURL"] as? String
                        self.friends.append(SearchUser(
                                                searchUserName: (document.data()!["Username"] as? String)!,
                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                searchUserUID: document.documentID))
                        print ("During \(friendsUID.count)")
                        print ("During \(self.friends.count)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print ("After \(friendsUID.count)")
                print ("After \(self.friends.count)")
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
    
}

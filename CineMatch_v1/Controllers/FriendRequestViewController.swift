import UIKit
import Firebase

class FriendRequestViewController: UIViewController {
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequests: [SearchUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        let userDetails = db.collection("User Details")
//        databaseManager.getFriendRequests(callback: { (friendRequestArray) in
//            for friendRequest in friendRequestArray {
//                userDetails.document(friendRequest).getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        let profileURLString = document.data()!["profileImageURL"] as? String
//                        self.friendRequests.append(SearchUser(
//                                                searchUserName: (document.data()!["Username"] as? String)!,
//                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
//                                                searchUserUID: document.documentID))
//                    }
//
//                    self.tableView.reloadData()
//                }
//
//            }
//
//        }
//        )
        
        var friendRequestsUID: [String] = []
        friendRequests = []
        userDetails.document(Auth.auth().currentUser!.uid)
            .addSnapshotListener (includeMetadataChanges: true) { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                friendRequestsUID = document.data()!["FriendRequestsReceived"] as! [String]
                print (friendRequestsUID)
                print (self.friendRequests)
                for friendRequestUID in friendRequestsUID {
                    
                    userDetails.document(friendRequestUID).addSnapshotListener (includeMetadataChanges: true) { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        let profileURLString = document.data()!["profileImageURL"] as? String
                        self.friendRequests.append(SearchUser(
                                                searchUserName: (document.data()!["Username"] as? String)!,
                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                searchUserUID: document.documentID))
                    }
                }
                print (self.friendRequests)
                self.tableView.reloadData()
                print (self.friendRequests)
            }
    
        print (friendRequests)
        tableView.register(UINib(nibName: "FriendReqCell", bundle: nil), forCellReuseIdentifier: "FriendReqCell")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        tableView.reloadData()
//    }
    
}

// MARK: - TableView DataSource Methods

extension FriendRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendReqCell", for: indexPath) as! FriendReqCell
        cell.friendReqName.text = friendRequests[indexPath.row].searchUserName
        cell.friendReqImage.image = friendRequests[indexPath.row].searchUserImage
        cell.friendReqUID = friendRequests[indexPath.row].searchUserUID
        
        
        return cell
    }

}

import UIKit
import Firebase

class FriendRequestViewController: UIViewController {
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequests: [SearchUser] = []

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        let userDetails = db.collection("User Details")
        databaseManager.getFriendRequests(callback: { (friendRequestArray) in
            for friendRequest in friendRequestArray {
                userDetails.document(friendRequest).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let profileURLString = document.data()!["profileImageURL"] as? String
                        self.friendRequests.append(SearchUser(
                                                searchUserName: (document.data()!["Username"] as? String)!,
                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                searchUserUID: document.documentID))
                    }

                    self.tableView.reloadData()
                }

            }

        }
        )
        
//        var friendRequestsUID: [String] = []
//        friendRequests = []
//        userDetails.document(Auth.auth().currentUser!.uid)
//            .addSnapshotListener () { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                friendRequestsUID = document.data()!["FriendRequestsReceived"] as! [String]
//                print ("Before \(friendRequestsUID.count)")
//                print ("Before \(self.friendRequests.count)")
//                for friendRequestUID in friendRequestsUID {
//
//                    userDetails.document(friendRequestUID).addSnapshotListener () { documentSnapshot, error in
//                        guard let document = documentSnapshot else {
//                            print("Error fetching document: \(error!)")
//                            return
//                        }
//                        let profileURLString = document.data()!["profileImageURL"] as? String
//                        self.friendRequests.append(SearchUser(
//                                                searchUserName: (document.data()!["Username"] as? String)!,
//                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
//                                                searchUserUID: document.documentID))
//                        print ("During 1 \(self.friendRequests.count)")
//                        print ("During 1 \(self.friendRequests.count)")
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                    print ("During \(self.friendRequests.count)")
//                    print ("During \(self.friendRequests.count)")
//                }
//            }
    
        print ("After \(friendRequests)")
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

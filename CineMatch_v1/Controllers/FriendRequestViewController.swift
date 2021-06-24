import UIKit
import Firebase

class FriendRequestViewController: UIViewController {
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequests: [SearchUser] = [
        SearchUser(searchUserName: "Mary Jane", searchUserImage: #imageLiteral(resourceName: "Mary Jane"), searchUserUID: ""),
        SearchUser(searchUserName: "Harry Osborn", searchUserImage: #imageLiteral(resourceName: "Harry Osborn"), searchUserUID: ""),
        SearchUser(searchUserName: "Gwen Stacy", searchUserImage: #imageLiteral(resourceName: "Gwen Stacy"), searchUserUID: "")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        db.collection("User Details").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
                    if document.documentID != Auth.auth().currentUser!.uid {
                        
                        if let username = document.data()["Username"] as? String,
                           let profileURLString = document.data()["profileImageURL"] as? String {
                            
                            self.friendRequests.append(SearchUser(searchUserName: username,
                                                       searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString),
                                                       searchUserUID: document.documentID))
                        }
                    }
                }
            }
        }
        
        tableView.register(UINib(nibName: "FriendReqCell", bundle: nil), forCellReuseIdentifier: "FriendReqCell")
    }
    
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
        return cell
    }
    
}

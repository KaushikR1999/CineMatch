import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    var friends: [SearchUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
//        db.collection("User Details").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    // print("\(document.documentID) => \(document.data())")
//
//                    if document.documentID != Auth.auth().currentUser!.uid {
//
//                        if let username = document.data()["Username"] as? String,
//                           let profileURLString = document.data()["profileImageURL"] as? String {
//
//                            self.friends.append(SearchUser(searchUserName: username,
//                                                       searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString),
//                                                       searchUserUID: document.documentID))
//                        }
//                    }
//                }
//            }
//        }
        
        friends = []
        let userDetails = db.collection("User Details")
        databaseManager.getFriends(callback: { (friendArray) in
            for friend in friendArray {
                userDetails.document(friend).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let profileURLString = document.data()!["profileImageURL"] as? String
                        self.friends.append(SearchUser(
                                                searchUserName: (document.data()!["Username"] as? String)!,
                                                searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                searchUserUID: document.documentID))
                    }
        
                    self.tableView.reloadData()
                }
                
            }
            
        }
        )
                
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

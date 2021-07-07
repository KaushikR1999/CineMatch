import UIKit
import Firebase




class FriendRequestViewController: UIViewController{
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequests: [SearchUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        loadTable()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    
    }
    
    func loadTable() {
        
        let userDetails = db.collection("User Details")
        
        self.friendRequests.removeAll()
        databaseManager.getFriendRequests(callback: { (friendRequestArray) in
            for friendRequest in friendRequestArray {
                
                userDetails.document(friendRequest)
                    .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        guard let data = document.data() else {
                            print("Document data was empty.")
                            return
                        }
                        let profileURLString = document.data()!["profileImageURL"] as? String
                        self.friendRequests.append(SearchUser(
                                                    searchUserName: (document.data()!["Username"] as? String)!,
                                                    searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString!),
                                                    searchUserUID: document.documentID))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
            }
            
        })

    tableView.register(UINib(nibName: "FriendReqCell", bundle: nil), forCellReuseIdentifier: "FriendReqCell")
    }
    
}



// MARK: - TableView DataSource Methods

extension FriendRequestViewController: UITableViewDataSource, FriendReqCellDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendReqCell", for: indexPath) as! FriendReqCell
        
        cell.delegate = self
        
        cell.friendReqName.text = friendRequests[indexPath.row].searchUserName
        cell.friendReqImage.image = friendRequests[indexPath.row].searchUserImage
        cell.friendReqUID = friendRequests[indexPath.row].searchUserUID
        
        
        return cell
    }
    
    
    func friendReqAcceptPressed(uid: String) {
        self.friendRequests.removeAll()
        databaseManager.acceptFriendReq(uid, callback: {
            self.loadTable()
        })
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    
    func friendReqDeclinePressed(uid: String) {
        self.friendRequests.removeAll()
        databaseManager.declineFriendReq(uid, callback: {
            self.loadTable()
        })
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
}



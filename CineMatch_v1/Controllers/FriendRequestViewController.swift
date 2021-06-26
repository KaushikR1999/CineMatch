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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTable()
        tableView.reloadData()
    
    }
    
    func loadTable() {
        
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
        databaseManager.acceptFriendReq(uid, callback: {
            self.loadTable()
            self.tableView.reloadData()
            
        })}
    
    
    
    func friendReqDeclinePressed(uid: String) {
        databaseManager.declineFriendReq(uid, callback: {
            self.tableView.reloadData()
        })}
}



import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    var searchUsers: [SearchUser] = []
    
    var searchUserResults: [SearchUser]!
    
    var username: String = ""
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        tableView.dataSource = self
        searchBar.delegate = self
        searchUserResults = []
        
        let userDetails = db.collection("User Details")
        
        userDetails.whereField("Username", isNotEqualTo: username)
            .addSnapshotListener () { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                DispatchQueue.global().async {
                    for document in documents {
                        
                        if document.documentID != Auth.auth().currentUser?.uid {
                            
                            if let username = document.data()["Username"] as? String,
                               let profileURLString = document.data()["profileImageURL"] as? String {
                                
                                self.searchUsers.append(SearchUser(searchUserName: username,
                                                                   searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString),
                                                                   searchUserUID: document.documentID))
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
    

        tableView.register(UINib(nibName: "FriendSessionCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUserResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchUserSessionCell
        cell.searchUserName.text = searchUserResults[indexPath.row].searchUserName
        cell.searchUserImage.image = searchUserResults[indexPath.row].searchUserImage
        cell.searchUserUID = searchUserResults[indexPath.row].searchUserUID
        cell.delegate = self
        
        databaseManager.checkIfFriends(cell.searchUserUID!, callback: { (ifFriends) in
            
            if ifFriends {
                cell.searchUserRequestButton.setImage(.none, for: .normal)
            } else {
                self.databaseManager.checkForFriendReqButton(cell.searchUserUID!, callback: { (ifSent) in
                    
                    if ifSent {
                        let image = UIImage(systemName: "circle.dashed")
                        cell.searchUserRequestButton.setImage(image, for: .normal)
                    } else {
                        let image = UIImage(systemName: "plus.circle.fill")
                        cell.searchUserRequestButton.setImage(image, for: .normal)
                    }
                }
                )
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        })
        return cell
    }
    
    // This method updates filteredFriends based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUserResults = searchText.isEmpty ? [] : searchUsers.filter { (item: SearchUser) -> Bool in
            return item.searchUserName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.autocapitalizationType = .none
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    

}

extension SearchViewController: SearchUserSessionCellDelegate {
    
    func SendFriendReq(uid: String, username: String) {
        
        databaseManager.sendFriendReq(uid)
    }
    
}

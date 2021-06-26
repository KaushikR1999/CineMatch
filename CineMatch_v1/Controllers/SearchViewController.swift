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
        
        db.collection("User Details").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
                    if document.documentID != Auth.auth().currentUser!.uid {
                        
                        if let username = document.data()["Username"] as? String,
                           let profileURLString = document.data()["profileImageURL"] as? String {
                            
                            self.searchUsers.append(SearchUser(searchUserName: username,
                                                       searchUserImage: self.databaseManager.retrieveProfilePic(profileURLString),
                                                       searchUserUID: document.documentID))
                        }
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
            cell.searchUserRequestButton.isHidden = ifFriends
            DispatchQueue.main.async {
                tableView.reloadData()
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

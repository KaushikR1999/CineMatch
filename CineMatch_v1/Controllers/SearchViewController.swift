import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friends: [Friend] = []
    
    var filteredFriends: [Friend]!
    
    var username: String = ""
    
    let db = Firestore.firestore()
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        tableView.dataSource = self
        searchBar.delegate = self
        filteredFriends = []
        
        db.collection("User Details").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    
                    if document.documentID != Auth.auth().currentUser!.uid {
                        
                        if let username = document.data()["Username"] as? String,
                           let profileURLString = document.data()["profileImageURL"] as? String {
                            
                            self.friends.append(Friend(friendName: username,
                                                       friendImage: self.databaseManager.retrieveProfilePic(profileURLString)))
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
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! FriendSessionCell
        cell.friendName.text = filteredFriends[indexPath.row].friendName
        cell.friendImage.image = filteredFriends[indexPath.row].friendImage
        return cell
    }
    
    // This method updates filteredFriends based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = searchText.isEmpty ? [] : friends.filter { (item: Friend) -> Bool in
            return item.friendName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        
        
        tableView.reloadData()
    }
}

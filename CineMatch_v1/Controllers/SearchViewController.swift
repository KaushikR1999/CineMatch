import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let friends: [Friend] = [
        Friend(friendName: "Mary Jane", friendImage: #imageLiteral(resourceName: "Mary Jane")),
        Friend(friendName: "Harry Osborn", friendImage: #imageLiteral(resourceName: "Harry Osborn")),
        Friend(friendName: "Gwen Stacy", friendImage: #imageLiteral(resourceName: "Gwen Stacy"))
    ]
    
    var filteredFriends: [Friend]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        tableView.dataSource = self
        searchBar.delegate = self
        filteredFriends = []
        
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

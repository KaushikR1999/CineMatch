//
//  SearchViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var userUIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        searchResultsTableView.register(SearchResultsTableViewCell.nib(), forCellReuseIdentifier: "SearchResultsTableViewCell")
        
        searchBar.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.tableFooterView = UIView()

        
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.userUIDs.removeAll()
            self.searchResultsTableView.reloadData()
        } else {
            DatabaseManager.shared.getSearchResults(with: searchText.lowercased()) { (uids) in
                self.userUIDs.removeAll()
                self.userUIDs.append(contentsOf: uids)
                DispatchQueue.main.async {
                    self.searchResultsTableView.reloadData()

                }
            }
            
            
        }

        
    }

    
    
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userUIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as!
            SearchResultsTableViewCell
        
        cell.configure(with: userUIDs[indexPath.row])
        
        return cell
    }
    
 
//
//    @objc func loadList(){
//            //load data here
//            searchResultsTableView.reloadData()
//        }

    
}



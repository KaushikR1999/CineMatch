//
//  ViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeTableViewBackgroundLabel: UILabel!
    var homeTables = [HomeTableModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        homeTableView.separatorStyle = .none

        
        homeTableView.register(FriendRequestsTableViewCell.nib(), forCellReuseIdentifier: "FriendRequestsTableViewCell")
        homeTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: "FriendsTableViewCell")
        
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
    
        DatabaseManager.shared.getFriendRequestsReceivedAndFriends {(data) in

            DispatchQueue.main.async {

                self.homeTables.removeAll()

                let friendRequestsReceived = data[0]
                let friends = data[1]
                
                self.homeTables.append(HomeTableModel.init(title: "Friend Requests", usersToDisplay: friendRequestsReceived))
                
                self.homeTables.append(HomeTableModel.init(title: "Friends", usersToDisplay: friends))

                if friendRequestsReceived.count != 0 {
                    self.tabBarController?.tabBar.items?.first?.badgeValue = String(friendRequestsReceived.count)
                } else {
                    self.tabBarController?.tabBar.items?.first?.badgeValue = nil
                }


                self.homeTableView.reloadData()
            }

        }

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

         return homeTables[section].usersToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if homeTables[section].usersToDisplay.count == 0 {
            return nil
        }
        
        return homeTables[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "FriendRequestsTableViewCell", for: indexPath) as!
                FriendRequestsTableViewCell
            
            cell.friendRequestProfilePicture.image = nil
            cell.friendRequestUsernameLabel.text = nil
            
            let uidData = homeTables[indexPath.section].usersToDisplay[indexPath.row]
            cell.configure(with: uidData)
            
            return cell
                        
        }
        
        else if indexPath.section == 1 {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as!
                FriendsTableViewCell
            
            cell.friendProfilePicture.image = nil
            cell.friendUsernameLabel.text = nil
            
            let uidData = homeTables[indexPath.section].usersToDisplay[indexPath.row]
            cell.configure(with: uidData)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if homeTables[0].usersToDisplay.count == 0 && homeTables[1].usersToDisplay.count == 0 {
            homeTableViewBackgroundLabel.text = "Search for users to add friends!"
            homeTableView.backgroundView = homeTableViewBackgroundLabel
            return 0

        } else if homeTables[section].usersToDisplay.count == 0 {
            return 0
        }

        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 1 {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let uidData = homeTables[indexPath.section].usersToDisplay[indexPath.row]
            let uid = uidData["uid"] as! String
            DatabaseManager.shared.deleteFriend(with: uid) {
//                DispatchQueue.main.async {
//                    self.homeTableView.reloadData()
//                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let uid = homeTables[indexPath.section].usersToDisplay[indexPath.row]["uid"] as! String
            DatabaseManager.shared.getSharedMovieIDs(with: uid) { (sharedMovieIDs) in
                print(sharedMovieIDs.count)
                let movieCollectionVC = self.storyboard?.instantiateViewController(identifier: "MovieCollectionViewController") as! MovieCollectionViewController
                movieCollectionVC.sharedMovieIDs = sharedMovieIDs
                self.navigationController?.pushViewController(movieCollectionVC, animated: true)
                
            }
            
        }
        

        
    }
    
    
//    let friend = friends[indexPath.row]
//    //friend.getSharedMovies
//
//    databaseManager.getSharedMovieIDS(friend: friend.searchUserUID) {movieIDS in
//        let collectionVC = self.storyboard?.instantiateViewController(identifier: "CollectionViewController") as! CollectionViewController
//        collectionVC.sharedMovieIDs = movieIDS
//        self.navigationController?.pushViewController(collectionVC, animated: true)
//
//    }

    
        
}





//
//  GroupViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 26/7/21.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var groupMessageLabel: UILabel!
    
    var groups = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTableView.register(GroupTableViewCell.nib(), forCellReuseIdentifier: "GroupTableViewCell")

        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        createGroupButton.layer.cornerRadius = 10
        
        
        
        DatabaseManager.shared.getGroups { (data) in
            
            
            DispatchQueue.main.async {

                self.groups.removeAll()
                self.groups.append(contentsOf: data)
                self.groupTableView.reloadData()
               
            }
        }
    
    }
    
    func presentAlert(with group: [String: Any], isCreator: Bool) {
        if isCreator {
            let alert = UIAlertController(
                title: "Are you sure you want to delete the group?",
                message:  "This will delete the group for all members involved!",
                preferredStyle: .alert)


            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (alertAction) in
                
                DatabaseManager.shared.removeGroup(with: group, isCreator: isCreator) { (success) in
                    if success {
                    }
                }
                
                
            }))
            
            self.present(alert, animated: true)
            
            
            
        }
        
        else {
            let alert = UIAlertController(
                title: "Are you sure you want to leave the group?",
                message:  "You cannot join back if you leave the group!",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (alertAction) in
                DatabaseManager.shared.removeGroup(with: group, isCreator: isCreator) { (success) in
                    if success {
                    }
                }
            }))
            
            self.present(alert, animated: true)
            
        }
    }

    
    
    
  
    
}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!
            GroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.configure(with: group)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let group = groups[indexPath.row]
        
        DatabaseManager.shared.getSharedMovieIDsGroup(with: group["members"] as! [String]) { (sharedMovieIDs) in
            let groupCollectionVC = self.storyboard?.instantiateViewController(identifier: "GroupCollectionViewController") as! GroupCollectionViewController
            
            groupCollectionVC.sharedMovieIDs = sharedMovieIDs
            groupCollectionVC.members = group["members"] as! [String]
            self.navigationController?.pushViewController(groupCollectionVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)

        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let group = groups[indexPath.row]
            
            let creator = group["creator"] as! String
            
            DatabaseManager.shared.isGroupCreator(with: creator) { (isCreator) in
                self.presentAlert(with: group, isCreator: isCreator)

            }

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if groups.count == 0 {
            
            self.groupMessageLabel.isHidden = false
            self.groupMessageLabel.text = "Create groups with your friends to view your matches with all of them!"
            self.groupTableView.backgroundView = self.groupMessageLabel
        
            return 0
        } else {
            self.groupMessageLabel.isHidden = true
        }
        
        return 0
    }
    
    
    

    
    
    
    
}

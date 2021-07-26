//
//  CreateGroupViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 26/7/21.
//

import UIKit

class CreateGroupViewController: UIViewController {

    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var friendsData = [[String: Any]]()
    var selectedFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: "FriendsTableViewCell")
        
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.isEditing = true
        
        cancelButton.layer.cornerRadius = 10
        createGroupButton.layer.cornerRadius = 10
        
        
        groupNameTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()

        DatabaseManager.shared.getFriendsData { (friendsData) in
            self.friendsData = friendsData
            
            DispatchQueue.main.async {
                self.friendTableView.reloadData()
            }
        }
    }
    


    
    @IBAction func createGroupButtonPressed(_ sender: UIButton) {
        
        if selectedFriends.count == 0 {
            presentAlert(with: "You can't create an empty group!")
        }
        
        else if groupNameTextField.text == "" {
            self.friendTableView.deselectAllRows(animated: true)
            presentAlert(with: "You can't create a group with no name!")
        }
        
        else {
            
            DatabaseManager.shared.createGroup(with: groupNameTextField.text!, groupMembers: selectedFriends) { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.presentAlert(with: "Unexpected error, please try again!")
                }
            }
        }
    }
    
    func presentAlert(with message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil))
        

        
        self.present(alert, animated: false)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreateGroupViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as!
            FriendsTableViewCell
        
        cell.friendProfilePicture.image = nil
        cell.friendUsernameLabel.text = nil
        
        let uidData = friendsData[indexPath.row]
        cell.configure(with: uidData)
        cell.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.1232090965, green: 0.1572110951, blue: 0.1998785436, alpha: 1)
        cell.tintColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        
        return cell
    }
    


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)

    }
    
    
}

extension CreateGroupViewController {
    
    func selectDeselectCell(tableView: UITableView, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.1232090965, green: 0.1572110951, blue: 0.1998785436, alpha: 1)
        selectedFriends.removeAll()
        if let arr = tableView.indexPathsForSelectedRows {
            for index in arr {
                selectedFriends.append(friendsData[index.row]["uid"] as! String)
            }
        }
        
        
    }
}

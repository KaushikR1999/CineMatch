//
//  SearchResultsTableViewCell.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 19/7/21.
//

import UIKit
import Kingfisher
import Firebase

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userRectangleView: UIView!
    @IBOutlet weak var userCellButton: UIButton!
    
    var userUID: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userRectangleView.layer.cornerRadius = 10
        userProfilePicture.layer.masksToBounds = true
        userProfilePicture.layer.cornerRadius = userProfilePicture.bounds.width/2.0
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    @IBAction func userCellButtonPressed(_ sender: UIButton) {
        
        DatabaseManager.shared.sendFriendRequest(with: userUID!) { (success) in
            
        }
    }
    
    
    public func configure(with uid: String) {
        
        userUID = uid
        
        DatabaseManager.shared.loadSearchUserCellDetails(with: uid) { (data) in
            
            DispatchQueue.main.async {
                self.userUsernameLabel.text = data["username"] as? String
                
                if let profilePictureURLString = data["profilePictureURL"] as? String {
                    self.userProfilePicture.kf.setImage(with: URL(string: profilePictureURLString), placeholder: UIImage(named: "defaultPic"), options: nil, completionHandler: nil)
                    
                }
                
                let friendStatus = data["friendStatus"] as! Int
                
                if friendStatus == 0 {
                    self.userCellButton.isHidden = true
                    self.userCellButton.isEnabled = false
                } else if friendStatus == 1 {
                    self.userCellButton.setImage(UIImage(systemName: "circle.dashed"), for: .normal)
                    self.userCellButton.setTitle("Pending", for: .normal)
                    self.userCellButton.isHidden = false
                    self.userCellButton.isEnabled = false
                } else {
                    self.userCellButton.setTitle("Add", for: .normal)
                    self.userCellButton.setImage(UIImage(systemName: "plus"), for: .normal)
                    self.userCellButton.isHidden = false
                    self.userCellButton.isEnabled = true
                }
                
            }
            
        }
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchResultsTableViewCell", bundle: nil)
    }
}

//
//  FriendRequestsTableViewCell.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 20/7/21.
//

import UIKit
import Kingfisher



class FriendRequestsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var friendRequestProfilePicture: UIImageView!
    @IBOutlet weak var friendRequestRectangleView: UIView!
    
    @IBOutlet weak var friendRequestUsernameLabel: UILabel!
    
    @IBOutlet weak var friendRequestAcceptButton: UIButton!
    
    
    @IBOutlet weak var friendRequestDeclineButton: UIButton!
    
    var userUID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendRequestRectangleView.layer.cornerRadius = 10
        friendRequestProfilePicture.layer.masksToBounds = true
        friendRequestProfilePicture.layer.cornerRadius = friendRequestProfilePicture.bounds.width/2.0
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FriendRequestsTableViewCell", bundle: nil)
    }
    
    @IBAction func friendRequestAcceptButtonPressed(_ sender: UIButton) {
        
        DatabaseManager.shared.acceptFriendRequest(with: userUID) {}
            
    }
        

    
    @IBAction func friendRequestDeclineButtonPressed(_ sender: UIButton) {

        DatabaseManager.shared.declineFriendRequest(with: userUID) {}
    }
    
    
    public func configure (with data: [String: Any]) {
        
        userUID = data["uid"] as! String 
        
        DispatchQueue.main.async {
            self.friendRequestUsernameLabel.text = data["username"] as? String

            if let profilePictureURLString = data["profilePictureURL"] as? String {
                self.friendRequestProfilePicture.kf.setImage(with: URL(string: profilePictureURLString), placeholder: UIImage(named: "defaultPic"), options: nil, completionHandler: nil)

            }
        }
    }

    
    public func configure(with uid: String) {

        userUID = uid


        DatabaseManager.shared.loadSearchUserCellDetails(with: uid) { (data) in

            DispatchQueue.main.async {
                self.friendRequestUsernameLabel.text = data["username"] as? String

                if let profilePictureURLString = data["profilePictureURL"] as? String {
                    self.friendRequestProfilePicture.kf.setImage(with: URL(string: profilePictureURLString), placeholder: UIImage(named: "defaultPic"), options: nil, completionHandler: nil)

                }
            }


        }

    }
}

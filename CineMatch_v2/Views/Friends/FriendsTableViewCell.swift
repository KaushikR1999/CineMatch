//
//  FriendsTableViewCell.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 20/7/21.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendProfilePicture: UIImageView!
    @IBOutlet weak var friendRectangleView: UIView!
    
    @IBOutlet weak var friendUsernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        friendRectangleView.layer.cornerRadius = 10
        friendProfilePicture.layer.masksToBounds = true
        friendProfilePicture.layer.cornerRadius = friendProfilePicture.bounds.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    static func nib() -> UINib {
        return UINib(nibName: "FriendsTableViewCell", bundle: nil)
    }
    
    public func configure (with data: [String: Any]) {

        DispatchQueue.main.async {
            self.friendUsernameLabel.text = data["username"] as? String

            if let profilePictureURLString = data["profilePictureURL"] as? String {
                self.friendProfilePicture.kf.setImage(with: URL(string: profilePictureURLString), placeholder: UIImage(named: "defaultPic"), options: nil, completionHandler: nil)

            }
        }
    }
    
    public func configure(with uid: String) {
        
        friendUsernameLabel.text = nil
        friendProfilePicture.image = nil
        
        DatabaseManager.shared.loadSearchUserCellDetails(with: uid) { (data) in
            
            DispatchQueue.main.async {
                self.friendUsernameLabel.text = data["username"] as? String
                
                if let profilePictureURLString = data["profilePictureURL"] as? String {
                    self.friendProfilePicture.kf.setImage(with: URL(string: profilePictureURLString), placeholder: UIImage(named: "defaultPic"), options: nil, completionHandler: nil)
                }
                
            }
            
        }
    }
    
}

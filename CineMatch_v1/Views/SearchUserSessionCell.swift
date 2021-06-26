//
//  FriendSessionCell.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 16/6/21.
//

import UIKit

protocol SearchUserSessionCellDelegate {
    
    func SendFriendReq(uid: String, username: String)
}

class SearchUserSessionCell: UITableViewCell {

    @IBOutlet weak var searchUserImage: UIImageView!
    @IBOutlet weak var searchUserBubble: UIView!
    @IBOutlet weak var searchUserName: UILabel!
    
    @IBOutlet weak var searchUserRequestButton: UIButton!
    
    var delegate : SearchUserSessionCellDelegate?
    
    var searchUserUID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchUserBubble.layer.cornerRadius = 10
        
        searchUserImage.layer.masksToBounds = true
        searchUserImage.layer.cornerRadius = searchUserImage.bounds.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func searchUserRequestPressed(_ sender: UIButton) {
        
        delegate?.SendFriendReq(uid: searchUserUID!, username: searchUserName.text!)
        
    
        
    }
    
}

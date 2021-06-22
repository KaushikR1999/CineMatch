//
//  FriendSessionCell.swift
//  CineMatch_v1
//
//  Created by L Kaushik Rangaraj on 16/6/21.
//

import UIKit

class FriendSessionCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendBubble: UIView!
    @IBOutlet weak var friendName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendBubble.layer.cornerRadius = 10
        
        friendImage.layer.masksToBounds = true
        friendImage.layer.cornerRadius = friendImage.bounds.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

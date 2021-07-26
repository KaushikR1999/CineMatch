//
//  GroupTableViewCell.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 26/7/21.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GroupTableViewCell", bundle: nil)
    }
    
    func configure(with group: [String: Any]) {
        groupName.text = group["name"] as! String
        
    }
}

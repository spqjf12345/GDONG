//
//  ChatListCell.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var roomName: UILabel!
    @IBOutlet var participants: UILabel!
    @IBOutlet var latestMessageTime: UILabel!
    
    
    override func awakeFromNib() {
        thumbnail.layer.cornerRadius = 10
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

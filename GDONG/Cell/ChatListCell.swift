//
//  ChatListCell.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit
import SDWebImage

class ChatListCell: UITableViewCell {

    @IBOutlet var thumbnail: SDAnimatedImageView!
    @IBOutlet var roomName: UILabel!
   
    @IBOutlet var latestMessageTime: UILabel!
    
    @IBOutlet var message: UILabel!
    
    @IBOutlet weak var peopleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbnail.layer.cornerRadius = 10
        //이미지뷰 모서리 설정
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

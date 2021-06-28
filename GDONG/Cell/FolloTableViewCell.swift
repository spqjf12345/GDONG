//
//  FolloTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/22.
//

import UIKit

class FolloTableViewCell: UITableViewCell {

    
    static var identifier = "FolloTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "RecentSFolloTableViewCellearchTableViewCell", bundle: nil)
    }
    
}

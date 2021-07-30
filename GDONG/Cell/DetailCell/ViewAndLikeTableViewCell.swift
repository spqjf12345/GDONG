//
//  ViewAndLikeTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/07.
//

import UIKit

class ViewAndLikeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    static var identifier = "ViewAndLikeTableViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ViewAndLikeTableViewCell", bundle: nil)
    }
    
    public func configure(view: Int, like: Int){
        viewCount.text = "조회수 \(view)"
        likeCount.text = "관심수 \(like)"
    }
}

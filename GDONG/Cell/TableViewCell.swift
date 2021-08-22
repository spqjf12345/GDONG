//
//  TableViewCell.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/11.
//

import UIKit
import SDWebImage
protocol TableViewCellDelegate {
    func moreButton(cell: TableViewCell)
}
class TableViewCell: UITableViewCell {
    
    @IBOutlet var productImageView: SDAnimatedImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    var delegate: TableViewCellDelegate?
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButton(_ sender: Any) {
        delegate?.moreButton(cell: self)
    }
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImageView.layer.cornerRadius = 10
        //imageview 모서리 설정
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}


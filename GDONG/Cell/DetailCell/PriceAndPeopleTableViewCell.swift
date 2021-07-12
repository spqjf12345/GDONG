//
//  PriceAndPeopleTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/07.
//

import UIKit

class PriceAndPeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceText: UILabel!
    
    @IBOutlet weak var people: UILabel!
    
    static var identifier = "PriceAndPeopleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PriceAndPeopleTableViewCell", bundle: nil)
    }

    public func configure(price: Int, nowPeople: Int, needPeople: Int){
        priceText.text = "\(price)원"
        people.text = "\(nowPeople) / \(needPeople) 명"
        
        
    }
    
}

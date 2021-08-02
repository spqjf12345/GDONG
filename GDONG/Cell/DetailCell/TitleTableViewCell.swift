//
//  TitleTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static var identifier = "TitleTableViewCell"
    
    
    @IBOutlet weak var titleBoard: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var dateBoard: UILabel!
    
    @IBOutlet weak var categoryBoard: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "TitleTableViewCell", bundle: nil)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        settingForLabel()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configure(with modelBoard: Board){
        self.titleBoard.text = modelBoard.title
        let dateDate = DateUtil.parseDate(modelBoard.createdAt!)
        let dateString = DateUtil.formatDate(dateDate)
        self.dateBoard.text = dateString
        self.userName.text = modelBoard.author
        self.categoryBoard.setTitle(modelBoard.category, for: .normal)
    }
    
    func settingForLabel(){
        self.titleBoard.font = UIFont.boldSystemFont(ofSize: 25)
        self.categoryBoard.setTitleColor(UIColor.white, for: .normal)
        self.categoryBoard.backgroundColor = UIColor.systemOrange
        self.categoryBoard.layer.cornerRadius = 5
        self.categoryBoard.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
}

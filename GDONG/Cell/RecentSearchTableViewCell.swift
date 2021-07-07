//
//  RecentSearchTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/16.
//

import UIKit
protocol RecentSearchTableViewCellDelegate: AnyObject {
    func didTapButton(cell: RecentSearchTableViewCell)
}

class RecentSearchTableViewCell: UITableViewCell {
    
    static var identifier = "RecentSearchTableViewCell"
    
    @IBOutlet weak var searchWord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    weak var cellDelegate: RecentSearchTableViewCellDelegate?
    
    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.didTapButton(cell: self)
    }
    static func nib() -> UINib {
        return UINib(nibName: "RecentSearchTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

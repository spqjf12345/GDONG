//
//  JusoTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/30.
//

import UIKit

class JusoTableViewCell: UITableViewCell {
    static var identifier = "JusoTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var common: UILabel!
    
    @IBOutlet weak var jibun: UILabel!
    
    
    @IBOutlet weak var doro: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "JusoTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
 
    
}

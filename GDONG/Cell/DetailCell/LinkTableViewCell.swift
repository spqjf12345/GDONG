//
//  LinkTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/07.
//

import UIKit

class LinkTableViewCell: UITableViewCell, UITextViewDelegate {
    static var identifier = "LinkTableViewCell"
    
    
 
    @IBOutlet weak var linkTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LinkTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(link: String){
        linkTextView.text = "\(link)"
        linkTextView.isScrollEnabled = false
        linkTextView.isEditable = false
        linkTextView.dataDetectorTypes = .link
    }
    

    
}

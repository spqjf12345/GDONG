//
//  ContentTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/07.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    static var identifier = "ContentTableViewCell"
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UISetting()
        contentView.addSubview(contentTextView)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UISetting(){
        contentTextView.isUserInteractionEnabled = true
        contentTextView.isSelectable = true
        contentTextView.isEditable = false
    }
    
    func calculate(){
  
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        print("1 \(contentTextView.height)")
    }
    
    
    
    
}

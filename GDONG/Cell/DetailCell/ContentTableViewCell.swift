//
//  ContentTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/07.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    static var identifier = "ContentTableViewCell"
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UISetting()
      
        calculate()
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
        //contentTextView.isScrollEnabled = false
 
    }
    
    func calculate(){

        frameView.translatesAutoresizingMaskIntoConstraints = false
        
        //2배 해줌
        frameView.heightAnchor.constraint(equalToConstant: contentTextView.height * 2).isActive = true
//        contentTextView.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 10).isActive = true
//        contentTextView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 10).isActive = true
//        contentTextView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -10).isActive = true
//        contentTextView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -10).isActive = true
        
        //height dynamic set
//        frameView.heightAnchor.constraint(equalToConstant: contentView.height).isActive = true
//        contentTextView.heightAnchor.constraint(equalToConstant: contentTextView.height).isActive = true
        
        print("height")
        print(contentView.height)
        print(contentTextView.height)

    }
    
    
    
    
}

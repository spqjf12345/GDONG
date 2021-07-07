//
//  categoryCollectionViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/03.
//

import UIKit

class categoryCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    static var identifier = "categoryCollectionViewCell"
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryText: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "categoryCollectionViewCell", bundle: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settupFont()
    }
    
    
    public func configure(with model: Category){
        let categoryImage = UIImage(named: model.categoryImage)

        self.categoryImage.image = categoryImage
        self.categoryImage.contentMode = .scaleAspectFill
        self.categoryImage.clipsToBounds = true
        self.categoryText.text = model.categoryText
    }
    
    func settupFont(){
        self.categoryText.font = .boldSystemFont(ofSize: 15)
    }

}

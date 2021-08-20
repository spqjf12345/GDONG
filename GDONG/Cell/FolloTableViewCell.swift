//
//  FolloTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/22.
//

import UIKit

protocol FolloTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(cell: FolloTableViewCell)
}

class FolloTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    static var identifier = "FolloTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    weak var cellDelegate: FolloTableViewCellDelegate?

 
    @IBAction func deleteButton(_ sender: Any) {
        print("delete ")
        cellDelegate?.didTapDeleteButton(cell: self)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FolloTableViewCell", bundle: nil)
    }
    
    public func configure(userName: String){
        //userImage Set 설정된 이미지가 있으면
        UserService.shared.getUserProfile(nickName: userName, completion: { (response) in
            print(response.profileImageUrl)
            if(response.profileImageUrl != ""){
                let urlString = Config.baseUrl + "/static/\(response.profileImageUrl)"
                if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                    print(myURL)
                    self.userImage.sd_setImage(with: myURL, completed: nil)
                    self.userImage.circle()
                }
            }else{
                let baseImage: UIImage? = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                self.userImage.image = baseImage
                self.userImage.circle()
            }
        })
        self.userName.text = userName
    }
    
}

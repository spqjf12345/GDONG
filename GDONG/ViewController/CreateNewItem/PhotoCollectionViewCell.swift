//
//  PhotoCollectionViewCell.swift
//  GDONG
//
//  Created by Woochan Park on 2021/05/26.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var deleteButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    imageView.contentMode = .scaleAspectFill
  }
  
  @IBAction func deletePhoto(_ sender: Any) {
    NotificationCenter.default.post(name: Notification.Name.UserDidDeletePhotoFromPhotoList, object: self)
  }
}

extension Notification.Name {
  static let UserDidDeletePhotoFromPhotoList = Notification.Name(rawValue: "UserDidDeletePhotoFromPhotoList")
}

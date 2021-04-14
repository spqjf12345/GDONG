//
//  DetailViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/10.
//

import UIKit

class DetailViewController: UIViewController {
    
    var productname = ""
    var productprice = ""
    var dtime = ""
    var dpeople = ""
    
    
    @IBOutlet var detailName: UILabel!
    @IBOutlet var detailTime: UILabel!
    @IBOutlet var detailCategory: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var detailPeople: UILabel!
    
    @IBAction func btnParticipate(_ sender: UIButton) {
        return
    }

    @IBAction func btnLike(_ sender: UIButton) {
        return
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailName.text = productname
        detailTime.text = dtime
        detailPeople.text = dpeople
        detailImage.image = UIImage(named: "apple.jpg")
        
        
        
    }
    
//    func productname(_ productName: String){
//        productname = productName
//        }
//
//    func productprice(_ productPrice: String){
//        productprice = productPrice
//        }
//
//    func dtime(_ time: String){
//        dtime = time
//        }
//
//    func dpeople(_ people: String){
//        dpeople = people
//        }

}

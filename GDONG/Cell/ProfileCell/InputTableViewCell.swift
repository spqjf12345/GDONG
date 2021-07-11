//
//  IDInputTableViewCell.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/04.
//

import UIKit
import CoreLocation

protocol InputTableViewCellDelegate {
    func change(cell: InputTableViewCell)
}

class InputTableViewCell: UITableViewCell, CLLocationManagerDelegate {
    

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var textfield: UITextField!
    
    static var identifier = "InputTableViewCell"
    
    var locationManager: CLLocationManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func IDChangeButton(_ sender: Any) {
        delegate?.change(cell: self)
        //이 cell을 위임하고 있는 메소드를 찾아 구현된 부분을 수행
    }
    
    var delegate: InputTableViewCellDelegate?
    var indexPath: IndexPath = []


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    static func nib() -> UINib {
           return UINib(nibName: "InputTableViewCell", bundle: nil)
    }
    
    func setLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let coor = locationManager.location?.coordinate
        let latitude = coor?.latitude
        let longitude = coor?.longitude

        print(latitude!)
        print(longitude!)

        let findLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")

        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(place, error) in
            if let address: [CLPlacemark] = place {
                if let name: String = address.last?.name{
                    print(name)
                    self.textfield.text = name
                }
            }
        })
    }


    
}

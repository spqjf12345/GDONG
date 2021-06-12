//
//  LocationViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/28.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationTextfield: UITextField!
    
    var getLocation = ""
    
    @IBAction func findCurrentLocaButton(_ sender: Any) {
        locationTextfield.text = currentLocation
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        guard let textField = locationTextfield.text else { return }
        if(textField == ""){
            self.showToast(message: "위치를 입력해주세요", font: UIFont.systemFont(ofSize: 10))
        }else{

        performSegue(withIdentifier: "search", sender: nil)
            

        }
    }
    var locationManager: CLLocationManager!
    var currentLocation = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! detailLocationViewController

        guard let textField = locationTextfield.text else { return }

        detailVC.searchKeyword = textField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(getLocation != nil){
            print("get location")
            locationTextfield.text = getLocation
        }else{
            locationTextfield.text = ""
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //foreground 일때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        let latitude = coor?.latitude
        let longitude = coor?.longitude
        
        print(latitude!)
        print(longitude!)
        
        let findLocation = CLLocation(latitude: 37.715133, longitude: 126.734086)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(place, error) in
            if let address: [CLPlacemark] = place {
                if let name: String = address.last?.name{
                    print(name)
                    self.currentLocation = name
                }
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}

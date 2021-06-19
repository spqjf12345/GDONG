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
    var getCLLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var myLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var nickName = ""
    
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
    
    @IBAction func nextButton(_ sender: Any) {
        //post location
        print(nickName)
        print(locationTextfield.text)
        if(getCLLocation.coordinate.latitude == 0.0 && getCLLocation.coordinate.longitude == 0.0){
            if(locationTextfield.text == currentLocation){
                //현재 위치 post
                print("현재 위치 ")
                print(myLocation.coordinate.latitude)
                print(myLocation.coordinate.longitude)
            }else {
                print("가져온 위치")
                print(getCLLocation.coordinate.latitude)
                print(getCLLocation.coordinate.longitude)
            }
            
        }
        
      
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(identifier: "login")
//        UIApplication.shared.windows.first?.rootViewController = loginVC
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
        print(nickName)
        print(getCLLocation.coordinate.latitude)
        print(getCLLocation.coordinate.longitude)
        
        
        if(getLocation != ""){
            locationTextfield.text = getLocation
        }else{
            locationTextfield.text = ""
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //foreground 일때 위치 추적 권한 요청
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        let latitude = coor?.latitude
        let longitude = coor?.longitude
        
        print(latitude!)
        print(longitude!)
        
        myLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(myLocation, preferredLocale: locale, completionHandler: {(place, error) in
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

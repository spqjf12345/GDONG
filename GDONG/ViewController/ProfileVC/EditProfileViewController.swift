//
//  EditProfileViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/22.
//

import UIKit
import CoreLocation
import PhotosUI

class EditProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    
    var userInfo = Users()
    @IBOutlet weak var imageEditButton: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func nickNameEditButton(_ sender: Any) {
        self.alertEditName()
    }
    
    
    @IBAction func locationEditButton(_ sender: Any) {
        self.alertEditLocation()
    }
    
    
    @IBAction func checkAccountInfo(_ sender: Any) {
        let connectedAccountVC = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "connectAccount")
            connectedAccountVC.modalPresentationStyle = .fullScreen
            self.present(connectedAccountVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var connectedAccountImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetting()
        UISetting()
       
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImage))
        imageEditButton.addGestureRecognizer(tapGestureRecognizer)
        imageEditButton.isUserInteractionEnabled = true

    }
    
    @objc func editImage(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func UISetting(){
        let authProvider = self.userInfo.authProvider
        switch authProvider {
        case "google":
            connectedAccountImage.image = UIImage(named: "google-logo")
            break
        case "kakao":
            connectedAccountImage.image = UIImage(named: "kakao-logo")
            break
        case "apple":
            connectedAccountImage.image = UIImage(named: "apple-logo")
            break
        default:
            print("\(authProvider) image loaded")
        }
        nickNameTextField.text =  self.userInfo.nickName
        self.getLocation()
        
        
        
    }
    
    func locationSetting(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //foreground 일때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    
    private var nameTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
    
    //check for validate name from server
    func haveSamenickName(name: String) -> Bool{
        if name == "jouureee"{
           return true
        }
        return false
    }
    
    
    //alertVC with textfield
    func alertEditName(){
        let alertVC = UIAlertController(title:"회원 정보 수정", message: nil, preferredStyle: .alert)
       
        alertVC.addTextField(configurationHandler: { (textField) -> Void in
            self.nameTextField = textField
            self.nameTextField.placeholder = "새로 수정할 닉네임을 입력해주세요"
        })
    
        let createAction = UIAlertAction(title: "create", style: .default, handler: { (action) -> Void in
            if let userInput = self.nameTextField.text  {
                let label = UILabel(frame:CGRect(x: 0, y: 40, width: 270, height:18))
                label.isHidden = true
                
                label.textColor = .red
                label.font = label.font.withSize(12)
                label.textAlignment = .center
                alertVC.view.addSubview(label)
                
                if userInput == ""{
                    label.text = "이름을 입력해주세요"
                    label.isHidden = false
                    self.present(alertVC, animated: true, completion: nil)

                }else if self.haveSamenickName(name: userInput){
                    label.text = "이미 같은 이름을 가진 사용자가 있습니다"
                    label.isHidden = false
                    self.present(alertVC, animated: true, completion: nil)
                }else{
                   //reflect
                    API.shared.updateNickname(nickName: userInput)
                    self.nickNameTextField.text = userInput
                }
            }
           
        })
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(createAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func alertEditLocation(){
        let alertVC = UIAlertController(title:"위치 정보 수정", message: nil, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: {
            (okAction) in
            //get Location func called
            self.getLocation()
        })
        let cancelAction =  UIAlertAction(title: "CANCEL", style: .cancel)
        alertVC.addAction(OkAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    
    func getLocation(){
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
                    self.locationTextField.text = name
                    API.shared.updateLocation(longitude: latitude!, latitude: longitude!)
                }
            }
        })
    }

}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, // <- background asyn type
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(image, error) in
                DispatchQueue.main.async {
                    self.userImage.image = image as? UIImage
                }
            })
        }else {
            print("cannot find image")
        }
    }
    
    
}

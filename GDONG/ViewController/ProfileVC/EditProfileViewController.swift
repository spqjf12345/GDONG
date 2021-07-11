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
    
    @IBOutlet var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
//
//    @IBOutlet weak var nickNameTextField: UITextField!
//
//
//    @IBOutlet weak var locationTextField: UITextField!
//
//    @IBAction func nickNameEditButton(_ sender: Any) {
//        self.alertEditName()
//    }
//
//
//    @IBAction func locationEditButton(_ sender: Any) {
//        self.alertEditLocation()
//    }
//
    
    func checktAccount(){
        let connectedAccountVC = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "connectAccount")
            connectedAccountVC.modalPresentationStyle = .fullScreen
            self.present(connectedAccountVC, animated: true, completion: nil)
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.circle()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImage))
        imageEditButton.addGestureRecognizer(tapGestureRecognizer)
        imageEditButton.isUserInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputTableViewCell.nib(), forCellReuseIdentifier: InputTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")


    }
    
    @objc func editImage(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func alertDone(title: String, message: String, completionHandler: @escaping ((String) -> Void)) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { action in  completionHandler("OK")})
        alertVC.addAction(OKAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
//    func UISetting(){
//        let authProvider = self.userInfo.authProvider
//        switch authProvider {
//        case "google":
//            connectedAccountImage.image = UIImage(named: "google-logo")
//            break
//        case "kakao":
//            connectedAccountImage.image = UIImage(named: "kakao-logo")
//            break
//        case "apple":
//            connectedAccountImage.image = UIImage(named: "apple-logo")
//            break
//        default:
//            print("\(authProvider) image loaded")
//        }
//        nickNameTextField.text =  self.userInfo.nickName
//        self.getLocation()
//
//
//
//    }
    
    func locationSetting(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
//
//        foreground 일때 위치 추적 권한 요청
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
    }

    
    func getLocation(cellField: UITextField){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let coor = locationManager.location?.coordinate
        guard let latitude = coor?.latitude, let longitude = coor?.longitude else {
            print("can not load location")
            return
        }

        print(latitude)
        print(longitude)

        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")

        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(place, error) in
            if let address: [CLPlacemark] = place {
                if let name: String = address.last?.name{
                    print(name)
                    cellField.text = name
                    API.shared.updateLocation(longitude: longitude, latitude: latitude)
                }
            }
        })
    }
    
    
//    //check for validate name from server
    func haveSamenickName(name: String) -> Bool{
        if name == "jouureee"{
           return true
        }
        return false
    }


    
    
    func alertEditLocation(cellField: UITextField){
        let alertVC = UIAlertController(title:"위치 정보 수정", message: nil, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: {
            (okAction) in
            //get Location func called
            self.getLocation(cellField: cellField)
        })
        let cancelAction =  UIAlertAction(title: "CANCEL", style: .cancel)
        alertVC.addAction(OkAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    private var nameTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
        
    
    func alertEditName(cellField: UITextField){
        let alertVC = UIAlertController(title: "회원 정보 수정", message: nil, preferredStyle: .alert)

        alertVC.addTextField(configurationHandler: { (textField) -> Void in
            self.nameTextField = textField
            self.nameTextField.placeholder = "새로 수정할 닉네임을 입력해주세요"
        })
        let label = UILabel(frame:CGRect(x: 0, y: 40, width: 270, height:18))
        
        let createAction = UIAlertAction(title: "create", style: .default, handler: { (action) -> Void in
            if let userInput = self.nameTextField.text  {
        
                label.isHidden = true
                label.textColor = .red
                label.font = label.font.withSize(12)
                label.textAlignment = .center
                label.text = ""
                alertVC.view.addSubview(label)

                if userInput == "" {
                    label.text = "이름을 입력해주세요"
                    label.isHidden = false
                    self.present(alertVC, animated: true, completion: nil)

                }else if self.haveSamenickName(name: userInput){
                    label.text = "이미 같은 이름을 가진 사용자가 있습니다"
                    label.isHidden = false
                    self.present(alertVC, animated: true, completion: nil)
                }else{
                   //reflect
                    API.shared.updateNickname(nickName: userInput, completion: {
                        (response) in
                        cellField.text = userInput
                        self.alertDone(title: "수정 완료", message: "닉네임이 변경되었습니다 ",  completionHandler: { response in
                            if(response == "OK"){
                                print("닉네임 \(userInput)으로 수정")
                                
                            }
                        })
                        

                    })
                    
                   
                }
            }

        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(createAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
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
                    if let image = image as? UIImage {
                        self.userImage.image = image
                        self.userImage.contentMode = .scaleAspectFill
                        if let imageData = image.jpeg(.lowest) {
                          
                            //post user setting image
                            API.shared.updateUserImage(userImage: imageData)
                        }
                        
                    }
                }

               
            })
        }else {
            print("cannot find image")
        }
    }
    
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource,InputTableViewCellDelegate {
    
    func change(cell: InputTableViewCell) {
        print("get \(cell.indexPath)")
        if(cell.indexPath[1] == 0){
            
            alertEditName(cellField: cell.textfield)
            
        }else if(cell.indexPath[1] == 1){
            
            alertEditLocation(cellField: cell.textfield)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // ID, Location
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.identifier)as! InputTableViewCell
            cell.label.text = "아이디 :"
            if let userNickName = UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) {
                cell.textfield.text = userNickName
            }
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.identifier) as! InputTableViewCell
            cell.label.text = "위치 :"
            cell.setLocation()
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
    }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

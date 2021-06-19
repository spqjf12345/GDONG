//
//  ProfileViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/03.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoOpenSDK
import GoogleSignIn
import CoreLocation


class ProfileViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userLocation: UILabel!
    
    @IBAction func editButton(_ sender: Any) {
        alertEditName()
    }
    
    @IBAction func locationEditbutton(_ sender: Any) {
        alertEditLocation()
    }
    
    @IBAction func connectAccount(_ sender: Any) {
        //get user account
        let connectedAccountVC = UIStoryboard.init(name: "MyPost", bundle: nil).instantiateViewController(withIdentifier: "connectAccount")
            connectedAccountVC.modalPresentationStyle = .fullScreen
            self.present(connectedAccountVC, animated: true, completion: nil)
        
        
    }
    
    private var nameTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
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
                    self.userName.text = userInput
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
    
    //check for validate name from server
    func haveSamenickName(name: String) -> Bool{
        if name == "jouureee"{
           return true
        }
        return false
    }
    
    private let sec = ["사용자 정보", "알림", "계정 설정"]
    var sec1 = ["내가 쓴 글"]
    var sec2 = ["알림 허용"]
    var sec3 = ["로그아웃", "회원 탈퇴", "앱 정보"]
    
    
    @IBOutlet weak var FrameTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(FrameTableView)
        
     
        FrameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        FrameTableView.delegate = self
        FrameTableView.dataSource = self
        userName.text = "jouureee"
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //foreground 일때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

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
                    self.userLocation.text = name
                }
            }
        })
    }

    @objc func didTapnoti(_ sender: UISwitch){
        if sender.isOn {
            print("turn")
            UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKey.notiState)

        }else{
            print("turn off")
            
        }
    }


}

class ConnectedViewController: UIViewController {
   
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        //get user info
    }
}





extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sec.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sec[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return sec1.count
        }else if (section == 1){
            return sec2.count
        }else if (section == 2){
            return sec3.count
        }
        return 0
       
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if indexPath.section == 0 {
            let text = UILabel()
            text.text = sec1[indexPath.row]
            cell.textLabel?.text = text.text
        }else if indexPath.section == 1 {
            let text = UILabel()
            text.text = sec2[indexPath.row]
            cell.textLabel?.text = text.text
            if(indexPath.row == 0){
                let mySwitch = UISwitch()
                //value store in userDefaults
                mySwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultKey.notiState)
                mySwitch.addTarget(self, action: #selector(didTapnoti), for: .touchUpInside)
                cell.accessoryView = mySwitch
            }
        }else if indexPath.section == 2 {
            let text = UILabel()
            text.text = sec3[indexPath.row]
            text.textColor = .red
            cell.textLabel?.text = text.text
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        guard let from = UserDefaults.standard.string(forKey: UserDefaultKey.authProvider) else { return }
        
        if indexPath.section == 0 && indexPath.row == 0 { // 내가 쓴 글, 찜한 글
            print("myPost indexpath")
           performSegue(withIdentifier: "myPost", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 0 { // 알림 허용
            print("alarm indexpath")
        }
        if indexPath.section == 2 && indexPath.row == 0 { // 로그 아웃
            self.autoLogout(from: from, title: "로그아웃", messege: "로그아웃 하시겠습니까?")
        }else if indexPath.section == 2 && indexPath.row == 1 { //회원 탈퇴
            self.autoLogout(from: from, title: "회원 탈퇴", messege: "회원을 탈퇴하시겠습니까?")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func autoLogout(from: String, title: String, messege: String){
        let alertVC = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            if(title == "회원 탈퇴"){
                API.shared.userQuit()
            }else{
                if(from == "google"){
                    print("auto login from google")
                    guard let signIn = GIDSignIn.sharedInstance() else { return }
                    signIn.signOut()
                }else if(from == "kakao"){
                    print("auto login from kakao")
                    UserApi.shared.logout {(error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("logout() success.")
                        }
                    }
                }else if(from == "apple"){
                    print("auto login from apple")
                }
                
            }
            
            self.moveToLoginVC()
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func moveToLoginVC(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userName)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userEmail)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.authProvider)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userNickName)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.isNewUser)

        
        let loginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login")
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}



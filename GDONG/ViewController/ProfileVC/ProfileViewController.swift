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

    var userInfo = User()
    var locationManager: CLLocationManager!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userLocation: UILabel!
    

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func profileSetting(_ sender: Any) {
        performSegue(withIdentifier: "EditProfile", sender: nil)
    }
    
    @IBOutlet weak var isSellerButton: UIButton!
    
    @IBOutlet weak var setFollwerCount: UIButton!
    
    @IBOutlet weak var setFollowingCount: UIButton!
    
    @IBAction func followerCount(_ sender: Any) {
        let dataString = "followers"
        performSegue(withIdentifier: "follo", sender: dataString)
    }
    
    @IBAction func followingCount(_ sender: Any) {
        let dataString = "following"
        performSegue(withIdentifier: "follo", sender: dataString)
    }
    
    @IBAction func LikePages(_ sender: Any) {
        performSegue(withIdentifier: "myPost", sender: nil)
    }
    
    private let sec = ["사용자 정보", "알림", "계정 설정"]
    var sec1 = ["판매자 인증하기"]
    var sec2 = ["메세지 알림 허용"]
    var sec3 = ["로그아웃", "회원 탈퇴", "앱 정보"]
    
    
    
    
    @IBOutlet weak var FrameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.getUserInfo(completion: { (response) in
            print("get user Info")
            self.userInfo = response
            self.userName.text = self.userInfo.nickName
            self.getLocation()
            self.setFollowingCount.setTitle("\(self.userInfo.following.count)", for: .normal)
            self.setFollwerCount.setTitle("\(self.userInfo.followers.count)", for: .normal)
            if(self.userInfo.isSeller == true){
                self.isSellerButton.isHidden = false
            }else {
                self.isSellerButton.isHidden = true
            }
        })
        
        FrameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        FrameTableView.delegate = self
        FrameTableView.dataSource = self
        
        
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
            UserDefaults.standard.setValue("jouureee", forKey: UserDefaultKey.userNickName)
            guard let nickName =  UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else { return }
            print(nickName)
            API.shared.pushNotification(nickname: nickName, message: "apn test message")
            UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKey.notiState)

        }else{
            print("turn off")
            
        }
    }


}

class ConnectedViewController: UIViewController {
   
    @IBOutlet weak var authProvider: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get user info
        authProvider.text?.append(UserDefaults.standard.string(forKey: UserDefaultKey.authProvider)!)
        userName.text?.append(UserDefaults.standard.string(forKey: UserDefaultKey.userName)!)
        userEmail.text?.append(UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let EditProfileVC = segue.destination as? EditProfileViewController {
            EditProfileVC.userInfo = self.userInfo
        }

    
        guard let FolloProfileVC = segue.destination as? FolloViewController, let dataFrom = sender as? String else { return }
        FolloProfileVC.dataFrom = dataFrom
        
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



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

class ProfileViewController: UIViewController {

    private let sec = ["알림", "설정", "계정 설정"]
    var tempLogout = ["로그아웃", "회원 탈퇴", "앱 정보"]
    
    private let FrameTableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(FrameTableView)
        FrameTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        FrameTableView.delegate = self
        FrameTableView.dataSource = self
     
    }


}



extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sec.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2
        }else if (section == 1){
            return 4
        }else if (section == 2){
            return tempLogout.count
        }
        return 0
       
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sec[section]
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if indexPath.section == 2 {
            let text = UILabel()
            text.text = tempLogout[indexPath.row]
            text.textColor = .red
            cell.textLabel?.text = text.text
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let from = UserDefaults.standard.string(forKey: "from") else { return }
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
        let okAction = UIAlertAction(title: "ok", style: .default, handler: {_ in
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
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func moveToLoginVC(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userName)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userEmail)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.accessToken)
        
        
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "from")
        
        let loginVC = LoginViewController()
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}



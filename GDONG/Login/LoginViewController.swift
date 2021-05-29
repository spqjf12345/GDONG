//
//  LoginViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/07.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoOpenSDK
import GoogleSignIn
import Alamofire
import CoreLocation

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, GIDSignInDelegate, CLLocationManagerDelegate {
    let viewModel = AuthenticationViewModel()
    var user: [User] = []
 
    
    //temp button
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()

    //for apple login button view
    private var appleLoginButtonView: UIStackView = {
        let appleLoginButtonView = UIStackView()
        appleLoginButtonView.backgroundColor = .systemGray
        return appleLoginButtonView
    }()
    
    //apple login button
    private let appleLoginButton:ASAuthorizationAppleIDButton = {
        let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonClick), for: .touchUpInside)
        return appleLoginButton
    }()
    
    private let kakaoTalkLoginButton:KOLoginButton = {
        let button = KOLoginButton()
        button.addTarget(self, action: #selector(onKakaoLoginByAppTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .standard
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkAutoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        GIDSignIn.sharedInstance()?.presentingViewController = self // 로그인화면 불러오기
        GIDSignIn.sharedInstance().restorePreviousSignIn() // 자동 로그인
        GIDSignIn.sharedInstance()?.delegate = self
        var locationManager: CLLocationManager!
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //foreground 일때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        googleLoginButton.frame = CGRect(x: 70, y: 300, width: 250, height: 40)
        kakaoTalkLoginButton.frame = CGRect(x: 70, y: googleLoginButton.bottom + 20, width: 250, height: 40)

        appleLoginButtonView.frame = CGRect(x: 70, y: kakaoTalkLoginButton.bottom + 20, width: 250, height: 40)
        appleLoginButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        loginButton.frame = CGRect(x: 70, y: appleLoginButtonView.bottom + 20, width: 250, height: 40)
      
        appleLoginButtonView.addArrangedSubview(appleLoginButton)
        view.addSubview(appleLoginButtonView)
        view.addSubview(kakaoTalkLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(loginButton)
    }
    
    //Apple Login
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case  let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            guard let identifyToken = appleIDCredential.identityToken else { return }
            guard let authoredCode = appleIDCredential.authorizationCode else { return }
            guard let fullName = appleIDCredential.fullName else { return }
            guard let email = appleIDCredential.email else { return }
            guard let tokeStr = String(data: identifyToken, encoding: .utf8) else { return }
            guard let codeStr = String(data: authoredCode, encoding: .utf8) else { return }
            
            print("Apple login")
            print("identifyToken : \(tokeStr)")
            print("authoredCode : \(codeStr)")
            print("User ID : \(userIdentifier)")
            print("User Email : \(email)")
            print("User Name : \(fullName)")
            self.autoLogin(UN: fullName.givenName! + fullName.familyName!, UE: email, FROM: "apple")

        default:
            break;
        }
        
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        // Handle error.
    }
    
    @objc func appleLoginButtonClick(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    

    //google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if(error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("the user has not signed in before or they have since signed out ")
            }else {
                print("error : \(error.localizedDescription)")
            }
            return
        }
        // 사용자 정보 가져오기
            if let userName = user.profile.name,
               let userEmail = user.profile.email,
               let idToken = user.authentication.idToken,
               let accessToken = user.authentication.accessToken { //send to server
                
                print("google login:")
                print("google token \(idToken)")
                print("User Email : \(userEmail)")
                print("User Name : \((userName))")
                self.autoLogin(UN: userName, UE: userEmail, FROM: "google")
                API.shared.oAuth(from: "google", access_token: accessToken, name: userName)
            } else {
                print("Error : User Data Not Found")
            }

    }
    
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
    @objc func didTapLoginButton(){
        //self.MoveToDetailView()
        //self.MoveToSearchView()
        self.MoveToTabbar()
    }
    
    
   
    //kakao login
    @objc func onKakaoLoginByAppTouched(_ sender: Any) {
        if(UserApi.isKakaoTalkLoginAvailable()){ // 이용가능하다면
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        let token = oauthToken
                        guard let gettoken = token else {
                            return
                        }
                        
                        
                        print("login token \(gettoken)")
                        self.setUserInfo()
                    }
                }
        }
    }
    
    func setUserInfo(){
        UserApi.shared.me(){(user, error) in
            if let error = error {
                print(error)
            }else{
                print("me() success")
                
                _ = user
                print("kakao login")
                guard let userId = user?.id else { return }
                guard let userName = user?.kakaoAccount?.profile?.nickname else { return }
                guard let userEmail = user?.kakaoAccount?.email else { return }
                print("user info : \(userId) \(userName) \(userEmail)")
                self.getToken()
                self.autoLogin(UN: userName, UE: userEmail, FROM: "kakao")
            }
        }
       
    }
    
    func getToken(){
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error {
                print(error)
            }
            else {
                print("accessTokenInfo() success.")
                guard let token = accessTokenInfo else { return }
                print("kakao login token \(token)")

            }
        }
    }
    
    func MoveToDetailView(){
//        print("moveto detailview")
        let detailVC = DetailNoteViewController()
        let navVC = UINavigationController(rootViewController: detailVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        navVC.pushViewController(detailVC, animated: true)
    }
    
    func MoveToSearchView(){
        let searchVC = SearchViewController()
        let navVC = UINavigationController(rootViewController: searchVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func MoveToTabbar(){
        
        let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
        let home = tabBarViewController.viewControllers![0] as! UINavigationController
        home.viewControllers.append(ViewController())
        let chat = tabBarViewController.viewControllers![1] as! UINavigationController
        let recommend = tabBarViewController.viewControllers![2] as! UINavigationController
        let profile = tabBarViewController.viewControllers![3] as! UINavigationController
        profile.viewControllers.append(ProfileViewController())
        tabBarViewController.setViewControllers([home, chat, recommend, profile], animated: true)

        UIApplication.shared.windows.first?.rootViewController = tabBarViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
 
    }
    
    func MoveToAdditionalInfo(){
       
        let nickVC = UIStoryboard.init(name: "AdditionalInfo", bundle: nil).instantiateViewController(withIdentifier: "nickName")
        
        let additionalNavVC = UINavigationController(rootViewController: nickVC)
       
        UIApplication.shared.windows.first?.rootViewController = additionalNavVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    func autoLogin(UN: String, UE: String, FROM: String){
        print("auto Login did")
        UserDefaults.standard.set(UN, forKey: "userName")
        UserDefaults.standard.set(UE, forKey: "userEmail")
        UserDefaults.standard.set(FROM, forKey: "from")
        //if user is new
        self.MoveToAdditionalInfo()
        //else
        //self.MoveToTabbar()
    }
    
    func checkAutoLogin(){
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            if let useremail = UserDefaults.standard.string(forKey: "userEmail") {
                print("has value in userDefaults")
                self.MoveToTabbar()
          }
        }else{
            print("need to meet the condition")
        }
        
    }

}

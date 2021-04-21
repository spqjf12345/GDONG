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

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, GIDSignInDelegate {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
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
            guard let fullName = appleIDCredential.fullName else { return }
            guard let email = appleIDCredential.email else { return }
            print("Apple login")
            print("User ID : \(userIdentifier)")
            print("User Email : \(email)")
            print("User Name : \(fullName)")
//            Apple login
//            User ID : 001607.55c65d33ebb84ff184c665342a5eaa79.0712
//            User Email : spqjf12345@naver.com
//            User Name : givenName: SoJeong familyName: Jo
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
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // 사용자 정보 가져오기
            if let userId = user.userID,                  // For client-side use only!
                let idToken = user.authentication.idToken, // Safe to send to the server
                let fullName = user.profile.name,
                let email = user.profile.email {
                print("google login:")
//                print("Token : \(idToken)")
//                print("User ID : \(userId)")
                print("User Email : \(email)")
                print("User Name : \((fullName))")
                self.MoveToDetailView()
            } else {
                print("Error : User Data Not Found")
            }

    }
    
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
    @objc func didTapLoginButton(){
        self.MoveToDetailView()
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
                guard let userId = user?.id else { return }
                guard let userName = user?.kakaoAccount?.profile?.nickname else { return }
                guard let userEmail = user?.kakaoAccount?.email else { return }
                
                print("user info : \(userId) \(userName) \(userEmail)")
                self.getToken()
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
                print("login token \(token)")
                
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

}

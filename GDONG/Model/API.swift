//
//  DataManger.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/21.
//

import Foundation
import Alamofire

class API {
    static var shared = API()
    
    func oAuth(from: String, access_token: String, name: String, completed: () -> Void){
        print("[API] /auth/signin/\(from)")
        guard let deviceToken: String = UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) else { return }
        let params: Parameters = [
            "access_token": access_token,
            "name": name,
            "device_token" : deviceToken
        ]

        AF.request(Config.baseUrl + "/auth/signin/\(from)", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString) ).validate().responseJSON {
            (response) in
            print("request result")
            if let httpResponse = response.response, let fields = httpResponse.allHeaderFields as? [String: String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.response?.url)!)
                print("cookie : \(cookies)")
                HTTPCookieStorage.shared.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)
                
                if let session = cookies.filter({$0.name == "token"}).first {
                    print("session : \(session.value)")
                    UserDefaults.standard.setValue(session.value, forKey: UserDefaultKey.jwtToken)
                    
                }
                
            }
            
            switch response.result {
            
            case .success(let obj):
                print(obj)
                print(type(of:obj))
                
                    do{
        
                        let responses = obj as! NSDictionary
                        
                        guard let user = responses["user"] as? Dictionary<String, Any> else { return }
                        
                        let isNew = responses["isNew"]
                        
                        let dataJSON = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)

                        let UserData = try JSONDecoder().decode(User.self, from: dataJSON)
                        print(UserData)

                        UserDefaults.standard.set(UserData.email, forKey: UserDefaultKey.userEmail)
                        UserDefaults.standard.set(access_token, forKey: UserDefaultKey.accessToken)
                        UserDefaults.standard.set(isNew, forKey: UserDefaultKey.isNewUser)
                        UserDefaults.standard.set(UserData.name, forKey: UserDefaultKey.userName)
                        UserDefaults.standard.set(UserData.nickName, forKey: UserDefaultKey.userNickName)
                        UserDefaults.standard.set(UserData.authProvider, forKey: UserDefaultKey.authProvider)
                        
                        self.autoLogin()
                        
                    }
                    catch let DecodingError.dataCorrupted(context) {
                            print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
            case .failure(let e):
                print(e.localizedDescription)
        }
            
    }
    completed()
        
    }
    
    
    //no such user
    func userQuit(){
        AF.request(Config.baseUrl + "/user/quit", method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
            print("user quit(회원 탈퇴) : \(response.result)")
            switch response.result {
            case .success(let code):
                print(code)
                break
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
    func update(nickName: String, longitude: Double, latitude: Double){
           let params: Parameters = [
               "nickname": nickName,
               "longitude": longitude,
               "latitude": latitude
           ]
           
           AF.request(Config.baseUrl + "/user/update", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON {
               (response) in
               print("[API] /user/update 유저 정보 업데이트")
               switch response.result {
               case .success(let obj):
                   print(obj)
               case .failure(let e):
                   print(e.localizedDescription)
               }
              
               }
           }
    
        func autoLogin(){
            print("auto Login did")
            //if user is new --> 1
            print(UserDefaults.standard.integer(forKey: UserDefaultKey.isNewUser))
            if UserDefaults.standard.integer(forKey: UserDefaultKey.isNewUser) == 1 {
                
                //MoveToAdditionalInfo
                let nickVC = UIStoryboard.init(name: "AdditionalInfo", bundle: nil).instantiateViewController(withIdentifier: "nickName")
                
                let additionalNavVC = UINavigationController(rootViewController: nickVC)
                UIApplication.shared.windows.first?.rootViewController = additionalNavVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }else {
                let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as! UITabBarController

                UIApplication.shared.windows.first?.rootViewController = tabBarViewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }

        }
    
    func setCookies(cookies: HTTPCookie){
        Alamofire.Session.default.session.configuration.httpCookieStorage?.setCookie(cookies)
    }

           
}


    
    



struct Config {
    static let baseUrl = "http://192.168.35.195:5000/api/v0" // test server url
}

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
    
    func oAuth(from: String, access_token: String, name: String){
        let params: Parameters = [
            "access_token": access_token,
            "name": name,
        ]

        AF.request(Config.baseUrl + "/auth/signin/\(from)", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON {
            (response) in
            print("request result")
            switch response.result {
            case .success(let obj):
                print(obj)
                print(type(of:obj))
                    do{
        
                        let response = obj as! NSDictionary
                        guard let user = response["user"] as? Dictionary<String, Any> else { return }
                        let isNew = response["isNew"]
                        
                        let dataJSON = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)

                        let UserData = try JSONDecoder().decode(User.self, from: dataJSON)
                        print(UserData)

                        UserDefaults.standard.set(UserData.email, forKey: UserDefaultKey.userEmail)
                        UserDefaults.standard.set(access_token, forKey: UserDefaultKey.accessToken)
                        UserDefaults.standard.set(isNew, forKey: UserDefaultKey.isNewUser)
                        UserDefaults.standard.set(UserData.name, forKey: UserDefaultKey.userName)
                        UserDefaults.standard.set(UserData.nickName, forKey: UserDefaultKey.userNickName)
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
        
    }
    
    
    //no such user
    func userQuit(){
        AF.request(Config.baseUrl + "/user/quit", method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
            print("user quit(회원 탈퇴) : \(response.result)")
            switch response.result {
            case .success(let code):
                print(code)
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
}



struct Config {
    static let baseUrl = "http://192.168.35.236:5000/api/v0" // test server url
}

//192.168.35.23
// 172.30.1.1
//192.168.35.192
//192.168.35.139
//  192.168.35.146


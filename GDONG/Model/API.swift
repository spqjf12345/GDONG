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
                    do{
//                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
//
//                        let UserData = try JSONDecoder().decode(User.self, from: dataJSON)
//                        print(UserData.authProvider)
//                        print(access_token)
//                        print(UserData.name)
//                        print(UserData.email)
//                        UserDefaults.standard.set(UserData.email, forKey: UserDefaultKey.userEmail)
                        UserDefaults.standard.set(access_token, forKey: UserDefaultKey.accessToken)
//                        UserDefaults.standard.set(UserData.name, forKey: UserDefaultKey.userName)
//                        UserDefaults.standard.set(UserData.nickName, forKey: UserDefaultKey.userNickName)
                    }catch {
                        print(error.localizedDescription)
                    }
                case .failure(let e):
                    print(e.localizedDescription)
            }
            
            
            
        }
        
    }
    
}



struct Config {
    static let baseUrl = "http://172.30.1.32:5000/api/v0" // test server url
}
// 172.30.1.1

//192.168.35.139
//  192.168.35.146


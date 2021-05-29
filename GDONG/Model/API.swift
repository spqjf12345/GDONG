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
    
    private var request: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    func oAuth(from: String, access_token: String, name: String){
        
        let params: Parameters = [
            "access_token": access_token,
            "name": name,
        ]
        
        AF.request(Config.baseUrl + "/auth/signin/\(from)", method: .get, parameters: params, encoding: URLEncoding.queryString).validate(statusCode: 200 ... 600).responseData {
            response in

            switch response.result {
            case .success:
                print("success")
                //print(HTTPCookieStorage.shared.cookies)

            case .failure(let e):
                print(e)
            }
        }
        
    }
    
}



struct Config {
    static let baseUrl = "http://192.168.35.101:5000/api/v0"
}

//192.168.35.139


//
//  ChatService.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/08/04.
//

import Foundation
import Alamofire

class ChatService {
    static var shared = ChatService()
    
    func joinChatList(postId: Int){
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return }
        
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(authorEmail); token=\(jwtToken)"
        ]
        
        let parameter:Parameters = ["postid" : postId]
        AF.request(Config.baseUrl + "/chat/join", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON(completionHandler: { (response) in

            print("[API] /chat/join \(postId) chatList에 추가")
            if let httpResponse = response.response, let fields = httpResponse.allHeaderFields as? [String: String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.response?.url)!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)

                //서버로 부터 받아오는 쿠키 값이 undefined가 아니면 앱 상 jwtToken 값 업데이트 하기
                if let session = cookies.filter({$0.name == "token"}).first {
                    print("============ Cookie vlaue =========== : \(session.value)")
                    if(session.value != "undefined"){
                        print("////////// update cookie value ///////")
                        UserDefaults.standard.setValue(session.value, forKey: UserDefaultKey.jwtToken)
                    }
                }
            }
            switch response.result {
                case .success(let obj):
                    print(obj)
                 case .failure(let e):
                     print(e.localizedDescription)
                 }
        })
    }
    
    func getChatList(postId: Int, completionHandler: @escaping (([Users]) throws -> (Void))){
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return }
        
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(authorEmail); token=\(jwtToken)"
        ]
        
        let parameter:Parameters = ["postid" : postId]
        AF.request(Config.baseUrl + "/chat/list", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON(completionHandler: { (response) in
            if let httpResponse = response.response, let fields = httpResponse.allHeaderFields as? [String: String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.response?.url)!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)

                //서버로 부터 받아오는 쿠키 값이 undefined가 아니면 앱 상 jwtToken 값 업데이트 하기
                if let session = cookies.filter({$0.name == "token"}).first {
                    print("============ Cookie vlaue =========== : \(session.value)")
                    if(session.value != "undefined"){
                        print("////////// update cookie value ///////")
                        UserDefaults.standard.setValue(session.value, forKey: UserDefaultKey.jwtToken)
                    }
                }
            }
            print("[API] /chat/join \(postId)에 참여 중인 list")
            switch response.result {
                case .success(let obj):
                    do {
                        let response = obj as! NSDictionary
                        print(response)
                        guard let list = response["list"] as? [Dictionary<String, Any>] else {
                            print("chatList data can't load")
                            return }
                        let dataJSON = try JSONSerialization.data(withJSONObject: list, options: .prettyPrinted)
                        let postData = try JSONDecoder().decode([Users].self, from: dataJSON)
                        try completionHandler(postData)
                    }
                    
                    catch {
                        print("error: ", error)
                    }
                 case .failure(let e):
                     print(e.localizedDescription)
                 }
        })
    }
    
    func quitChatList(postId: Int){
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return }
        
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(authorEmail); token=\(jwtToken)"
        ]
        
        let parameter:Parameters = ["postid" : postId]
        AF.request(Config.baseUrl + "/chat/quit", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON(completionHandler: { (response) in
            if let httpResponse = response.response, let fields = httpResponse.allHeaderFields as? [String: String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.response?.url)!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)

                //서버로 부터 받아오는 쿠키 값이 undefined가 아니면 앱 상 jwtToken 값 업데이트 하기
                if let session = cookies.filter({$0.name == "token"}).first {
                    print("============ Cookie vlaue =========== : \(session.value)")
                    if(session.value != "undefined"){
                        print("////////// update cookie value ///////")
                        UserDefaults.standard.setValue(session.value, forKey: UserDefaultKey.jwtToken)
                    }
                }
            }
            print("[API] /chat/join \(postId) 채팅방 나가기")
            switch response.result {
                case .success(let obj):
                    print(obj)
                 case .failure(let e):
                     print(e.localizedDescription)
                 }
        })
    }
}

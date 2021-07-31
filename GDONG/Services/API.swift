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
    
    func getUserInfo(completion: @escaping ((Users) -> Void) ){
        AF.request(Config.baseUrl + "/user/info", method: .get, parameters: nil).validate().responseJSON {
            (response) in
            switch response.result {
            
                case .success(let obj):
                    do {
                        let responses = obj as! NSDictionary
                        guard let user = responses["user"] as? Dictionary<String, Any> else { return }
                        
                        let dataJSON = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)

                        let UserData = try JSONDecoder().decode(Users.self, from: dataJSON)
                        completion(UserData)
                    } catch {
                        print("error: ", error)
                    }
                    
                    
                case .failure(let e):
                    print(e.errorDescription as Any)
            }
        }
    }
        
    func oAuth(from: String, access_token: String, name: String) {
        print("[API] /auth/signin/\(from)")
        guard let deviceToken: String = UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) else { return }
        let params: Parameters = [
            "access_token": access_token,
            "name": name,
            "device_token" : deviceToken
        ]
       

        AF.request(Config.baseUrl + "/auth/signin/\(from)", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON {
            (response) in
            if let httpResponse = response.response, let fields = httpResponse.allHeaderFields as? [String: String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.response?.url)!)
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

                        let UserData = try JSONDecoder().decode(Users.self, from: dataJSON)
                        print(UserData)

                        UserDefaults.standard.set(UserData.email, forKey: UserDefaultKey.userEmail)
                        UserDefaults.standard.set(access_token, forKey: UserDefaultKey.accessToken)
                        UserDefaults.standard.set(isNew, forKey: UserDefaultKey.isNewUser)
                        UserDefaults.standard.set(UserData.name, forKey: UserDefaultKey.userName)
                        UserDefaults.standard.set(UserData.authProvider, forKey: UserDefaultKey.authProvider)
                        UserDefaults.standard.set(UserData.nickName, forKey: UserDefaultKey.userNickName)
                        
                        API.shared.autoLogin()
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
                print("connected failed")
                print(e.localizedDescription)
//                LoginViewController().alertController( completion: {
//                ok in
//                if(ok == "OK"){
//                    
//                    exit(0) //앱 종료
//                    
//                }
//                })
                
                
        }
            
    }

    //로그인 옵저버
    NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        
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
    
    
    func updateNickname(nickName: String, completion: @escaping ((String) -> Void) ){
        let params: Parameters = [
               "nickname": nickName
           ]
        
        guard let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            return
        }
        
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            return
        }

        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Set-Cookie" : "email=\(email); token=\(jwtToken)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            print("[API] /post/upload")
        
            for (key, value) in params {
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    print(temp)
                }
                
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    print(temp)
               }

            }
           
            
        }, to: Config.baseUrl + "/user/update", usingThreshold: UInt64.init(), method: .post, headers: headers).validate().responseJSON { (response) in

            print("[API] /user/update 유저 닉네임 업데이트")
            switch response.result {
            case .success(let obj):
                print(obj)
                do {
                    let responses = obj as! NSDictionary
                    guard let user = responses["user"] as? Dictionary<String, Any> else { return }
                    
                    let dataJSON = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)

                    let UserData = try JSONDecoder().decode(Users.self, from: dataJSON)
                    completion(UserData.nickName)
                } catch {
                    print("error: ", error)
                }
                
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func updateLocation(longitude: Double, latitude: Double){
        print(longitude)
        print(latitude)
        let params: Parameters = [
            "longitude": longitude,
            "latitude": latitude
        ]
        
        guard let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            return
        }
        
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            return
        }

        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Set-Cookie" : "email=\(email); token=\(jwtToken)"
        ]
        
        
        AF.upload(multipartFormData: { multipartFormData in
            print("[API] /user/update 유저 위치 정보 업데이트")
        
            for (key, value) in params {
                if let temp = value as? Double {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    print(temp)
                }
                
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    print(temp)
               }

            }
           
            
        }, to: Config.baseUrl + "/user/update", usingThreshold: UInt64.init(), method: .post, headers: headers).validate().responseJSON { (response) in

            switch response.result {
            case .success(let obj):
                print(obj)
//                do {
//                    let responses = obj as! NSDictionary
//                    guard let user = responses["user"] as? Dictionary<String, Any> else { return }
//
//                    let dataJSON = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
//
//                    let UserData = try JSONDecoder().decode(Users.self, from: dataJSON)
//                    completion(UserData.nickName)
//                } catch {
//                    print("error: ", error)
//                }
                
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        
        
        
//        AF.request(Config.baseUrl + "/user/update", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON {
//            (response) in
//            print("[API] /user/update 유저 위치 정보 업데이트")
//            switch response.result {
//            case .success(let obj):
//                print(obj)
//            case .failure(let e):
//                print(e.localizedDescription)
//            }
//           
//            }
    }
    
    func updateUserImage(userImage: Data) {
        let url = Config.baseUrl + "/post/upload"
        guard let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("updateUserImage email no")
            return
        }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            print("updateUserImage jwtToken no")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Set-Cookie" : "email=\(email); token=\(jwtToken)"
        ]
        
        
        AF.upload(multipartFormData: { multipartFormData in
            print("[API] /user/update 유저 이미지 업데이트")
            
            print("image string get from AF : \(String(describing: String.init(data: userImage, encoding: .utf8)))")
            
            multipartFormData.append(userImage, withName: "images", fileName: "\(userImage).jpg", mimeType: "image/jpg")
           
        }, to: url,usingThreshold: UInt64.init(), method: .post, headers: headers).validate().responseJSON { (response) in
            
            do {
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("String Data: \(utf8Text)") // original server data as UTF8 string
//                    let BoardData = try JSONDecoder().decode(Board.self, from: data)
//                    completionHandler(BoardData)
                }
              
                
            }catch {
                print("error: ", error)
            }
            
            
        }
    }
    
    func userFollow(nickName: String){
        let parameters: [String: Any] = ["nickname": nickName]
    
        
        guard let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("updateUserImage email no")
            return
        }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            print("updateUserImage jwtToken no")
            return
        }
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(email); token=\(jwtToken)"
        ]
        
        AF.request(Config.baseUrl + "/user/follow", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            print("[API] user 팔로우: \(response.result)")
            switch response.result {
            case .success(let code):
                print(code)
                break
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        
    }
    
    func userUnfollow(nickName: String){
        let parameters: [String: Any] = ["nickname": nickName]
    
        
        guard let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("updateUserImage email no")
            return
        }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            print("updateUserImage jwtToken no")
            return
        }
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(email); token=\(jwtToken)"
        ]
        
        AF.request(Config.baseUrl + "/user/unfollow", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            print("[API] user 언팔로우: \(response.result)")
            switch response.result {
            case .success(let code):
                print(code)
                break
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        
    }
    
    func pushNotification(nickname: String, message: String){
        
        let parameters: [String: Any] = ["nickname": nickname, "message": message]
        var request = URLRequest(url: URL(string: Config.baseUrl + "/apn/push")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
       
        let formDataString = (parameters.compactMap({(key, value) -> String in
            return "\(key)=\(value)" }) as Array).joined(separator: "&")
        let formEncodedData = formDataString.data(using: .utf8)
        
        request.httpBody = formEncodedData
        AF.request(request).responseJSON { (response) in
            print(response)
            print("[API] /apn/push apn push 메세지 보내기")
            switch response.result {
            case .success(let obj):
                print(obj)
                
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        
    }
        
    
    
    func getauthorPost(start: Int, author: String, num: Int, completion: @escaping (([Board]?) -> Void)){
        let params: Parameters = ["start" : start,
                                "author": author,
                                  "num": num]
    
        AF.request(Config.baseUrl + "/post/author", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON { (response) in
                print(response)
                print("[API] /post/author \(author) 유저 게시글 가져오기")
                switch response.result {
                    case .success(let obj):
                        do {
                           let responses = obj as! NSDictionary
                            print(responses)
                           let posts = responses["posts"] as Any
                           let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)

                           let authorBoard = try JSONDecoder().decode([Board]?.self, from: dataJSON)
                            print("authorBoard \(authorBoard!)")
                            completion(authorBoard)
                        } catch let DecodingError.dataCorrupted(context) {
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
    
    
    func getMyHeartPost(nickName: String,  completion: @escaping (([Board]?) -> Void)){
        let params: Parameters = ["nickname" : nickName]
        AF.request(Config.baseUrl + "/post/likelist", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON { (response) in
                print(response)
                print("[API] /post/likeList \(nickName)가 좋아요 한 글 가져오기")
                switch response.result {
                    case .success(let obj):
                        do {
                           let responses = obj as! NSDictionary
                            //print(responses)
                            let posts = responses["posts"] as Any
                           let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)

                           let heartBoard = try JSONDecoder().decode([Board]?.self, from: dataJSON)
                            print("hearted post -> \(heartBoard!)")
                            completion(heartBoard)
                        } catch let DecodingError.dataCorrupted(context) {
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
    
    func checkAutoLogin() -> Bool {
        guard let from = UserDefaults.standard.string(forKey: UserDefaultKey.authProvider) , let accseeToken = UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) , let name = UserDefaults.standard.string(forKey: UserDefaultKey.userName) , let jwt = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else {
            print("저장된 정보가 없어 login view로 이동")
            return false
        }
        
        if from != "", accseeToken != "", name != "", jwt != "" {
            oAuth(from: from, access_token: accseeToken, name: name)
            return true
        }
        return false
    }
    
    
    func autoLogin(){
        print("autoLogin method call")
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
    
    func findAddress(keyword: String, completion: @escaping ((JusoResponse) -> Void)){
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        
        let parameters: [String: Any] = ["confmKey": "devU01TX0FVVEgyMDIxMDUzMDAxMDMzNzExMTIyMjE=",
                                                    "currentPage": "1",
                                                    "countPerPage":"10",
                                                    "keyword": keyword,
                                                    "resultType": "json"]
    
        AF.request(url, method: .get, parameters: parameters).responseJSON{ [weak self] (response) in
            guard let self = self else { return }
            if let value = response.value {
                if let jusoResponse: JusoResponse = self.toJson(object: value) {
                    completion(jusoResponse)
                    }else {
                        print("serialize error")
                    }
            }
        }
    }
        
    private func toJson<T: Decodable>(object: Any) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
                    let decoder = JSONDecoder()
                    
                    
                    if let result = try? decoder.decode(T.self, from: jsonData) {
                        return result
                    } else {
                        return nil
                    }
                } else {
                  return nil
                }

    }

           
}




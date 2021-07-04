//
//  PostService.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/04.
//

import Foundation
import Alamofire
import CoreLocation

class PostService {
    static var shared = PostService()
    
    func uploadPost(title: String, content: String, link: String, needPeople: Int, price: Int, category: String, images: [Data], profileImg: String, location: Location, completionHandler: @escaping (Board) -> Void){
        let url = Config.baseUrl + "/post/upload"
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        guard let author =  UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else { return }
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        let tags:[String] = ["과일", "샤인머스켓"]
        
        let parameter:Parameters = ["author" : author,//
                         "email" : authorEmail,//
                         "title" : title,//
                         "content": content,//
                         "link" : link, //
                         "needPeople" : needPeople, //
                         "price" : price, //
                         "category": category,
                         "images": images,//
                         //"tags": tags,
                         "profileImg" : profileImg,
                         "location":location]
        
        AF.upload(multipartFormData: { multipartFormData in
            print("[API] /post/upload")
            for imageData in images {
                print("image string get from AF : \(String.init(data: imageData, encoding: .utf8))")
                multipartFormData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpg")
            }
            for (key, value) in parameter {
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    print(temp)
                }
                
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    print(temp)
               }
                
//                if let temp = value as? NSArray { // tags
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let string = element as? String {
//                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                            if let num = element as? Int {
//                                let value = "\(num)"
//                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//                    print(temp)
//                }

                if value is Location {
                    do {
                        let jsonData = try JSONEncoder().encode(location)
                        let jsonString = String(data: jsonData, encoding: .utf8)!
                        print("location json \(jsonString)")
                        multipartFormData.append("\(jsonData)".data(using: .utf8)!, withName: key)
                        
                    }catch {
                        print("jsonError \(error.localizedDescription)")
                    }
               }

                
            }
           
            
        }, to: url,usingThreshold: UInt64.init(), method: .post, headers: headers).validate().responseJSON { (response) in
            
            do {
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("String Data: \(utf8Text)") // original server data as UTF8 string
                    let BoardData = try JSONDecoder().decode(Board.self, from: data)
                    completionHandler(BoardData)
                }
                if let json = response.value {
                    print("JSON Response : \(json)") // serialized json response
                }
                
            }catch {
                print("error: ", error)
            }
            
            
        }
    }
}
        
        

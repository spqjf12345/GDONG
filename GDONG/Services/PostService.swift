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
    
    func getPosts(completion: @escaping (([Board]) -> Void)){
        let parameter:Parameters = ["start" : -1,
                                    "num" : 5] // start : -1 처음부터 ~ 5개
        AF.request(Config.baseUrl + "/post/recent", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: { (response) in

            print("[API] post/recent")
            switch response.result {
                case .success(let obj):
                    do {
                       let responses = obj as! NSDictionary
                        print("response is \(responses)")
                       guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
                        print("posts is \(posts)")
        
                        let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)

                        let postData = try JSONDecoder().decode([Board].self, from: dataJSON)
                        print("postData is \(postData)")
                        completion(postData)
//                        var board = [Board]()
//                        
//                        for i in postData {
//                            
//                            board.append(i)
//                        }
//                        completion(board)
                    
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
        })
        
    }
    
    func getImage(fileName:String){
        let url = Config.baseUrl + "/static"
        let parameter: Parameters = ["filename" : fileName]
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentURL = URL(fileURLWithPath: documentPath, isDirectory: true)
            let fileURL = documentURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, method: .get, parameters: parameter, encoding: JSONEncoding.default, to: destination).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
         }
        .response { response in
                 debugPrint(response)
         if response.error == nil, let imagePath = response.fileURL?.path {
                     let image = UIImage(contentsOfFile: imagePath)
                                            
                     UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

                 }
             }
    }
        
    }

        
        

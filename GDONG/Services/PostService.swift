//
//  PostService.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/07/04.
//

import Foundation
import Alamofire
import CoreLocation


class PostService: RandomNumberGenerator {
    static var shared = PostService()

    
    func deletePost(postId: Int){
        
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return }
        
        
        let headers: HTTPHeaders = [
            "Set-Cookie" : "email=\(authorEmail); token=\(jwtToken)"
        ]
        
        let parameter:Parameters = ["postid" : postId]
        AF.request(Config.baseUrl + "/post/delete", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON(completionHandler: { (response) in

            print("[API] post/delete \(postId) 번째 게시글 삭제")
            switch response.result {
                case .success(let obj):
                    print(obj)
                 case .failure(let e):
                     print(e.localizedDescription)
                 }
        })
    }
    
    func uploadPost(title: String, content: String, link: String, needPeople: Int, price: Int, category: String, images: [Data], profileImg: String, location: Location, completionHandler: @escaping (Board) -> Void){
        let url = Config.baseUrl + "/post/upload"
        
        guard let author =  UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else { return }
        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return }
        
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
            
        ]

        let parameter:Parameters = ["author" : author,//
                         "email" : authorEmail,//
                         "title" : title,//
                         "content": content,//
                         "link" : link, //
                         "needPeople" : needPeople, //
                         "price" : price, 
                         "category": category,
                         "images": images,
                         "profileImg" : "1234test",
                         "location":location]
            

        
        AF.upload(multipartFormData: { multipartFormData in
            print("[API] /post/upload")

        for imageData in images {
            var fileName = "\(imageData).jpg"
            fileName = fileName.replacingOccurrences(of: " ", with: "_") 
            print(fileName)
            multipartFormData.append(imageData, withName: "images", fileName: fileName, mimeType: "image/jpg")
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


        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate().responseJSON { (response) in
            switch response.result {

            case .success(let obj):
                do {
                    let response = obj as! NSDictionary
                    print("PostService : \(response["post"])")
                    guard let post = response["post"] as? Dictionary<String, Any> else {
                        print("post data can't get")
                        return }
                    print("post in PostService : \(post)")
                    let dataJSON = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
                    let postData = try JSONDecoder().decode(Board.self, from: dataJSON)
                    completionHandler(postData)

                }catch {
                    print("error: ", error)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
//            do {
//
//                let responses = obj as! NSDictionary
//                 print(response)
//                 //print(String(data: response.data!, encoding: .utf8))
//
//                 guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
//                  let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)
//                  let postData = try JSONDecoder().decode([Board].self, from: dataJSON)
//
//
//                if let jsonData = response.data {
//                    let responseObj = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
//                    if let response = responseObj as? [String: Any] {
//                        if let data = response["post"] as? [String : Any]{
//                            completionHandler(data["postid"] as! Int)
//                            print("json :  \(data["postid"])") }
//                        }
//                    }
//
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("String Data: \(utf8Text)") // original server data as UTF8 string
//                    let BoardData = try JSONDecoder().decode(Board?.self, from: data)
//                    print(BoardData)
//                    completionHandler(BoardData)
//                }
//                if let json = response.value {
//                    print("JSON Response : \(json)") // serialized json response
//                }
//
//            }catch {
//                print("error: ", error)
//            }

        }
    }
    
    func getAllPosts(completion: @escaping (([Board]?) -> Void)){
        let parameter:Parameters = ["start" : -1,
                                    "num" : 10] // start : -1 처음부터 ~ 5개
        AF.request(Config.baseUrl + "/post/recent", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: { (response) in

            print("[API] post/recent")
            switch response.result {
                case .success(let obj):
                    do {
                       let responses = obj as! NSDictionary
               
                       guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
                        //print(posts)
                        let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)
                        let postData = try JSONDecoder().decode([Board]?.self, from: dataJSON)
                        completion(postData)
                    
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
    
    func clickHeart(postId: Int){
        
        let parameter: Parameters = ["postid": postId]
        AF.request(Config.baseUrl + "/post/like", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: {
            (response) in
                print(response)
                print("[API] /post/like 좋아요 누르기")
                
                switch response.result {
                    case .success(let obj):
                        do {
                           let responses = obj as! NSDictionary
                            print(response)
                        
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
    
    func getSearchPost(start: Int, searWord: String, num: Int, completion: @escaping (([Board]) -> Void)){
        let parameter: Parameters = ["start" : start,
                                    "word" : searWord,
                                    "num" : num]
        
        AF.request(Config.baseUrl + "/post/search", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: {
            (response) in

                print("[API] /post/search \(searWord)에 해당하는 글 가져오기")
                
                switch response.result {
                    case .success(let obj):
                        do {
                           let responses = obj as! NSDictionary
                            print(response)
                            //print(String(data: response.data!, encoding: .utf8))
                    
                            guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
                             let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)
                             let postData = try JSONDecoder().decode([Board].self, from: dataJSON)
                             completion(postData)
                            
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
    
    func getCategoryPost(start: Int, category: String, num: Int, completion: @escaping (([Board]) -> Void)){
        let parameter: Parameters = ["start" : start,
                                    "category" : category,
                                    "num" : num]
        
        AF.request(Config.baseUrl + "/post/category", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: {
            (response) in

                print("[API] /post/category \(category)에 해당하는 글 가져오기")
                
                switch response.result {
                    case .success(let obj):
                        do {
                           let responses = obj as! NSDictionary
                            print(response)
                            //print(String(data: response.data!, encoding: .utf8))
                    
                            guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
                             let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)
                             let  postData = try JSONDecoder().decode([Board].self, from: dataJSON)
                             completion(postData)
                            
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
    
    func filteredPost(start: Int, num: Int, min_price: Int, max_price: Int, min_dist: Int, max_dist: Int, sortby: String, completion: @escaping (([Board]) -> Void)){
        
        let parameter: Parameters = [ "start" : start,
                                    "num" : num,
                                    "min_price" : min_price,
                                    "max_price" : max_price,
                                    "min_dist": min_dist,
                                    "max_dist" : max_dist,
                                    "sortby" : sortby
                                    ]
        
        AF.request(Config.baseUrl + "/post/filter", method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseJSON(completionHandler: {
            (response) in
            print("[API] /post/filter 된 글 가져오기")
            
            switch response.result {
                case .success(let obj):
                    do {
                       let responses = obj as! NSDictionary
                        print(response)
                        //print(String(data: response.data!, encoding: .utf8))
                
                        guard let posts = responses["posts"] as? [Dictionary<String, Any>] else { return }
                         let dataJSON = try JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted)
                         let postData = try JSONDecoder().decode([Board].self, from: dataJSON)
                         completion(postData)
                        
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
    
}




    
//    func getImage(fileName:String, completion: @escaping ((Data?) -> Void)){
//        let url = Config.baseUrl + "/static/\(fileName)"
//        let URL = URL(string: url)
//        let data = Data(contentsOf: URL!)
//        return data
//        
//    }


        //let parameter: Parameters = ["filename" : fileName]
        
        
        
//        AF.request(url, method: .get, parameters: parameter, encoding: URLEncoding(destination: .queryString)).validate().responseData(completionHandler: {(response) in
//            print("[API] /static/fileName 이미지 받아오기")
////            let temp = base64String.components(separatedBy: ",")
//            let dataDecoded : Data = Data(base64Encoded: (response.data?.base64EncodedString())!, options:
//             .ignoreUnknownCharacters)!
//            let decodedimage = UIImage(data: dataDecoded)
////
////            yourImage.image = decodedimage
//           // guard let uiimage: UIImage = UIImage(data: response.data!) else { return }
//            //print("uiimage \(uiimage)")
//            print(decodedimage)
//            print(response.data?.base64EncodedString())
//            
//            completion(response.data)
//
//        })
        
//        let destination: DownloadRequest.Destination = { _, _ in
//
//            //let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            let url = Config.baseUrl + "/static/"
//            let filepath = url.appending("/\(fileName)")
//
//            let fileURL = URL.init(fileURLWithPath: filepath, isDirectory: false)
//
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
////            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
////            let documentURL = URL(fileURLWithPath: documentPath, isDirectory: true)
////            let fileURL = documentURL.appendingPathComponent(fileName)
////            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }

        

//        AF.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination).downloadProgress { progress in
//            print(destination)
//            print("Download Progress: \(progress.fractionCompleted)")
//         }
//        .response { response in
//                 debugPrint(response)
//                 if response.error == nil, let imagePath = response.fileURL?.path {
//                let image = UIImage(contentsOfFile: imagePath)
//
//                     UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//
//                 }
//             }
 //   }
//}




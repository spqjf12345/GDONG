//
//  DatabaseManager.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/25.
//

import Foundation
import FirebaseDatabase
import MessageKit

struct chatAppUSer {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {
    public func userExits(with email: String, completion: @escaping((Bool) -> (Void))){
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    ///insert new user to database
    public func insertUSer(with user: chatAppUSer, completion: @escaping (Bool)->Void){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name" : user.lastName
        ], withCompletionBlock: {error, _ in
            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    //append to user dictionary
                    let newElement = [
                        "name" :user.firstName + " " + user.lastName,
                        "email" : user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }else{
                    //create taht array
                    let newCollection: [[String: String]] = [
                        ["name" :user.firstName + " " + user.lastName,
                         "email" : user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
            
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        
    }
    
}

//extension DatabaseManager {
//    public func test(){
//        self.database.child("TEST")
//        database.setValue(["NAME" : "HI"])
//    }
//    /// Fetches and returns all conversations for the user with passed in email
//       public func getAllConversations(for email: String, completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
//        self.database.child("ChatRoom").observe(.value, with: { snapshot in
//               guard let value = snapshot.value as? [[String: Any]] else{
//                   completion(.failure(DatabaseError.failedToFetch))
//                   return
//               }
//                
//  
//               let conversations: [ChatRoom] = value.compactMap({ dictionary in
//                   guard let conversationId = dictionary["id"] as? String,
//                       let name = dictionary["name"] as? String,
//                       let otherUserEmail = dictionary["other_user_email"] as? String,
//                       let latestMessage = dictionary["latest_message"] as? [String: Any],
//                       let date = latestMessage["date"] as? String,
//                       let text = latestMessage["message"] as? String,
//                       let isRead = latestMessage["is_read"] as? Bool,
//                       let thumbnail = dictionary["thumbnail"] as? String,
//                       let user = dictionary["users"] as? [String: String],
//                       let messages = dictionary["messages"] as? [[String: Any]]
//                       else {
//                           return nil
//                   }
//
//                   let latestMmessageObject = LatestMessage(date: date,
//                                                            text: text,
//                                                            isRead: isRead)
//                 
//                print(messages)
//                var messageAll = [Message]()
//                var kind: MessageKind?
//                
//                for i in messages {
//                    
//                    let content = i["content"] as? String
//                    let date = i["date"] as? String
//                    let id = i["id"] as? String
//                    let senderName = i["sender_nickName"] as? String
//                    let type = i["type"] as? String
//                    let sender = Sender(photoURL: "",
//                                    senderId: email,
//                                    displayName: senderName!)
//                    let dateFormatter = DateFormatter()
//                    kind = .text(content!)
//                    let message = Message(sender: sender, messageId: id!, sentDate: (dateFormatter.date(from: date!)!), kind: kind!)
//                    print(message)
//                    messageAll.append(message)
//                }
//                
//                
//                var users = [String]()
//                
//                for i in user {
//                    users.append(i.value)
//                }
//                return ChatRoom(id: conversationId, roomName: name, thumbnail: thumbnail, parcipants: users, latestMessage: latestMmessageObject, messages: messageAll, allowedNotification: false)
//                 
//               })
//
//               completion(.success(conversations))
//           })
//       }
//    
//    
//}

//extension DatabaseManager {
//    public func createNewChatRoom(with otherUSerEmail: String, name: String, firstMessage: Message, postTitle, completion: @escaping (Bool) -> Void){
//        let ref = database.child("\(postTitle)")
//    }
//}

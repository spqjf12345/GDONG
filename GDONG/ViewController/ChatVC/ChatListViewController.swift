//
//  ChatListViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit
import FirebaseFirestore

//fireStore에 저장될 데이터 모델
struct ChatRoom {
    var chatId: String?
    var chatRoomName: String?
    var chatRoomDate: Date?
    var chatImage: String?
    
    init(chatId: String, chatRoomName: String, chatRoomDate: Date, chatImage:String){
        self.chatId = chatId
        self.chatRoomName = chatRoomName
        self.chatRoomDate = chatRoomDate
        self.chatImage = chatImage
    }
}

class ChatListViewController: UIViewController {
    var mychatRoom = [ChatRoom]()
    var userCount = [Int]()
    
//    var roomName = ["딸기사실분 선착순입니다!어서어서 들어오세요","향수 공동구매 해요!어서어서 들어오세요"]
//    var thumnail = ["strawberry.jpg", "perfume.jpg"]
//    var latestMessageTime = ["1시간전", "2021.4.28"]
//    var message = ["안녕하세요 채팅내용 입니다 이건 마지막 채팅내용이 나타날 자리 입니다.", "1/80"]
    
    //private var conversations = [ChatRoom]()

    var currentUser: Users = Users()
    
    @IBOutlet var chatListTableView: UITableView!
    
    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "ChatListCell", bundle: nil)

        chatListTableView.register(nibName, forCellReuseIdentifier: "chatList")
        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        API.shared.getUserInfo(completion: { (response) in
            self.currentUser = response
        })
        
        loadChat()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatListTableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        let index = chatListTableView.indexPathForSelectedRow
        chatVC.chatRoom = self.mychatRoom[index!.row]
        
    }
    
    public func loadChat(){
        guard let myEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else{
            print("there are no email")
            return
        }
        
        //useremail 을 가진 document들을 불러옴
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: myEmail)
        db.getDocuments { (chatQuerySnap, error) in
        if let error = error {
            print("Error: \(error)")
            return
        } else {
            guard let queryCount = chatQuerySnap?.documents.count else {
                print("date is no queryCount")
                return
                }
                if(queryCount == 0){
                    print("아직 채팅 방이 없음")
                }else if queryCount >= 1 {
                    print("query count is \(queryCount)")
                    for doc in chatQuerySnap!.documents {
                        print(doc.documentID) //N9f8ugKxMGslE8oNusnA
                        guard let ChatRoomName = doc.data()["ChatRoomName"] as? String else {
                            print("no chat room name in database")
                            return
                        }
                        
                        guard let ChatRoomDate = doc.data()["Date"] as? Timestamp else {
                            print("no chat room date in database")
                            return
                        }
                        
                        guard let users = doc.data()["users"] as? [String] else {
                            print("no users string array in database")
                            return
                        }
                        self.userCount.append(users.count)
                        
                        guard let ChatImage = doc.data()["ChatImage"] as? String else {
                            print("no ChatImage string in database")
                            return
                        }
                        
                        
                        self.mychatRoom.append(
                            ChatRoom(chatId: doc.documentID, chatRoomName: ChatRoomName, chatRoomDate: Date(timeIntervalSince1970: TimeInterval(ChatRoomDate.seconds)), chatImage: ChatImage))
                        
                     
                        print(self.mychatRoom)
                    }
//                    if(self.mychatRoom.count > 1){
//                        self.chatListTableView.reloadData()
//                    }
                   
                }
            }
           
        }
        
        
    }
    public func deleteFromChat(indexPath: IndexPath, completed: @escaping (String)-> (Void)){
        
        guard let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("deleteFromChat no userEmail")
            return
        }
       
        guard let chatRoomId = mychatRoom[indexPath.row].chatId else {
            return
        }
        
        let postId = Int(chatRoomId)
        
        print("deleteFromChat test")
        let document = Firestore.firestore().collection("Chats").document("\(chatRoomId)")
        document.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let users = document.data()!["users"] as? [String] else {
                    print("no users string array in database")
                    return
                }
                
                if(users.count == 1){ //유저가 한명만 남았을 때(방장일때 밖에 없음) 방 삭제
                    print("user count is 1")
                    
                    //채팅방 삭제
                    self.deleteChatRoom(postId: postId!)
                    //게시글 삭제
                    PostService.shared.deletePost(postId: postId!)
                    completed("OK")
                }else { // 아직 유저 여러명일때
                    // 글쓴이인경우 == users[0]
                    if(users[0] == userEmail){
                        self.alertViewController(title: "나가기 실패", message: "글쓴이인경우 채팅방을 나갈 수 없습니다.", completion: {(response) in
                        })
                        completed("NO")
                    }else {
                        // 글쓴이가 아닌경우 -> 채팅방에서 나가기
                        self.deleteUser(indexPath: indexPath)
                        completed("OK")
                    }
                   
                }
       
            } else {
                print("Document does not exist")
            }
        }

        
        
       
        
    }
    
    public func deleteChatRoom(postId: Int){
        print("deleteChatRoom called")
  
        
        Firestore.firestore().collection("Chats").document("\(postId)").delete(){ err in
            if let err = err {
                self.alertViewController(title: "채팅방 삭제 실패", message: "채팅방이 존재하지 않습니다.", completion: { (response) in })
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
    
    func deleteUser(indexPath: IndexPath){
        guard let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("deleteFromChat no userEmail")
            return
        }
       
        guard let chatRoomId = mychatRoom[indexPath.row].chatId else {
            return
        }
        let document = Firestore.firestore().collection("Chats").document("\(chatRoomId)")

        document.updateData([
            "users": FieldValue.arrayRemove(["\(userEmail)"])
        ])
        print("유저 아직 여러명 -> \(userEmail) 유저만 삭제")
        
    }
        
    
    
//    private func getConversation() {
//        guard let email = UserDefaults.standard.value(forKey: UserDefaultKey.userEmail) as? String else {
//            return
//        }
//
//        if let observer = loginObserver {
//            NotificationCenter.default.removeObserver(observer)
//        }
//
//        print("starting conversation fetch...")

       // let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        // get all conversation
        //DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] (result) in
               //                                     print(result)})
 //       DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak //self] result in
//            switch result {
//            case .success(let conversations):
//                print("successfully got conversation models")
//                guard !conversations.isEmpty else {
//                    self?.tableView.isHidden = true
//                    self?.noConversationsLabel.isHidden = false
//                    return
//                }
//                self?.noConversationsLabel.isHidden = true
//                self?.tableView.isHidden = false
//                self?.conversations = conversations
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                self?.tableView.isHidden = true
//                self?.noConversationsLabel.isHidden = false
//                print("failed to get convos: \(error)")
//            }
//        })    }

}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mychatRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        
        cell.roomName.text = mychatRoom[indexPath.row].chatRoomName
        let dateString = DateUtil.formatDate(mychatRoom[indexPath.row].chatRoomDate!)
        
        cell.latestMessageTime.text = dateString
        cell.peopleLabel.text =  "\(userCount[indexPath.row])명 참여 중"
        
        if let indexImage =  mychatRoom[indexPath.row].chatImage {
            //print("index image \(indexImage)")
            let urlString = Config.baseUrl + "/static/\(indexImage)"
            if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                cell.thumbnail.sd_setImage(with: myURL, completed: nil)
            }
        }
      
        cell.roomName.sizeToFit()
        cell.latestMessageTime.sizeToFit()
        cell.message.sizeToFit()
        cell.thumbnail.sizeToFit()
        cell.peopleLabel.sizeToFit()
        
        
        return cell
        
    }
    
//    // this method handles row deletion
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            // remove the item from the data model
//            animals.remove(at: indexPath.row)
//
//            // delete the table view row
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        } else if editingStyle == .insert {
//            // Not used in our example, but if you were adding a new row, this is where you would do it.
//        }
//    }
    
    //swipe 하여 채팅방 나가기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "나가기") { (action, view, success) in
            
            //swipe 할 때의 action 정의
           
            self.deleteFromChat(indexPath: indexPath, completed: {(response) in
                if(response != "NO"){
                    self.mychatRoom.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                tableView.reloadRows(at: [indexPath], with: .fade)
            })
            
        
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])

        return config
        
    }

    
    //chat 방 들어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chat", sender: nil)
    }
    
}

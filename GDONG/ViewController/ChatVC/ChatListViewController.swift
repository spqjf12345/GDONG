//
//  ChatListViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit
import FirebaseFirestore
import PagingTableView

//fireStore에 저장될 데이터 모델
struct ChatRoom {
    var chatId: String?
    var chatRoomName: String?
    var chatRoomDate: Date?
    var chatImage: String?
    var latestMessage: Message
    
    init(chatId: String, chatRoomName: String, chatRoomDate: Date, chatImage:String, latestMessage: Message){
        self.chatId = chatId
        self.chatRoomName = chatRoomName
        self.chatRoomDate = chatRoomDate
        self.chatImage = chatImage
        self.latestMessage = latestMessage
    }
}

class ChatListViewController: UIViewController {
    var mychatRoom = [ChatRoom]()
    var userCount = [Int]()
    var mychatRoomitem = [ChatRoom]()
    var lastestMessage: Message?

    var currentUser: Users = Users()
    
    @IBOutlet var chatListTableView: PagingTableView!


    
    //페이징을 위한 데이터 가공
    let numberOfItemsPerPage = 2

      func loadData(at page: Int, onComplete: @escaping ([ChatRoom]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          let firstIndex = page * self.numberOfItemsPerPage
          guard firstIndex < self.mychatRoomitem.count else {
            onComplete([])
            return
          }
          let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.mychatRoomitem.count ?
            (page + 1) * self.numberOfItemsPerPage : self.mychatRoomitem.count
            print("last index \(lastIndex)")
          onComplete(Array(self.mychatRoomitem[firstIndex ..< lastIndex]))
        }
      }
    
    //당겨서 새로고침시 갱신되어야 할 내용
    @objc func pullToRefresh(_ sender: UIRefreshControl) {
        self.chatListTableView.refreshControl?.endRefreshing() // 당겨서 새로고침 종료
        self.chatListTableView.reloadData() // Reload하여 뷰를 비워주기

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        loadChat(from: "")
        print("reload")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "ChatListCell", bundle: nil)

        chatListTableView.register(nibName, forCellReuseIdentifier: "chatList")
        
        chatListTableView.pagingDelegate = self
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        UserService.shared.getUserInfo(completion: { (response) in
            self.currentUser = response
        })
        
        self.chatListTableView.refreshControl?.endRefreshing() // 당겨서 새로고침 종료
        self.chatListTableView.reloadData()
        
        //당겨서 새로고침
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

        
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        let index = chatListTableView.indexPathForSelectedRow
        chatVC.chatRoom = self.mychatRoom[index!.row]
        
    }
    
    public func loadChat(from: String){
        print("load chat called")
        if(!mychatRoom.isEmpty){ //viewwillapear 시 mychatRoom 비우고 다시 로드
            mychatRoom.removeAll()
        }
        
        guard let myNickName = UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else {
            self.alertViewController(title: "유효하지 않은 사용자", message: "다시 로그인을 진행해주세요", completion: { (response) in})
            return
        }
        

        
        //nickName 을 가진 document들을 불러옴
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: myNickName)
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
                        
                        //최근 메시지 불러오기
                        let postId = doc.documentID
                     
                        self.getLatestMessge(docId: postId, completed: { (message) in
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
                                ChatRoom(chatId: doc.documentID, chatRoomName: ChatRoomName, chatRoomDate: Date(timeIntervalSince1970: TimeInterval(ChatRoomDate.seconds)), chatImage: ChatImage, latestMessage: message)
                             )
                            if(from == "detail"){
                                print("from create and called ")
                            }else {
                                self.chatListTableView.reloadData()
                            }
                            
                            
                            print(self.mychatRoom)
                        })
                      

                        
                    }
                    
                    if(self.mychatRoom.count > 1){
                        self.chatListTableView.reloadData()
                    }
                   
                }
            }
           
        }
        
        
    }
    
    
    
    public func getLatestMessge(docId: String, completed: @escaping (Message) -> (Void)){
        print("docId \(docId)")
        
        Firestore.firestore().collection("Chats").document("\(docId)").collection("thread").order(by: "created", descending: true).getDocuments() { (querySnapshot ,err) in
            if let err = err {
                        print("Error getting documents: \(err)")
                completed(Message(id: "", content: "", created: Date(), senderID: "", senderName: ""))
                    } else {
                        
                        if(querySnapshot!.documents.first?.data().isEmpty != nil){ // 최근 문자 있다면
                            guard let content = querySnapshot!.documents.first?.data()["content"] as? String else {
                                  print("content type error")
                                  return
                              }

                          guard let id = querySnapshot!.documents.first?.data()["id"] as? String else {
                              print("id type error")
                              return

                          }

                          guard let created = querySnapshot!.documents.first?.data()["created"] as? Timestamp else {
                              print("created type error")
                              return
                          }
                          guard let senderName = querySnapshot!.documents.first?.data()["senderName"] as? String else {
                              print("senderName type error")
                              return
                          }

                          guard let senderID = querySnapshot!.documents.first?.data()["senderID"] as? String else {
                              print("senderID type error")
                              return
                          }
                            print("latest message : \(Message(id: id, content: content, created: Date(timeIntervalSince1970: TimeInterval(created.seconds)), senderID: senderID, senderName: senderName))")
                            completed(Message(id: id, content: content, created: Date(timeIntervalSince1970: TimeInterval(created.seconds)), senderID: senderID, senderName: senderName))
                        }else { // 최근 문자 없을 시 빈 문자열 리턴
                            completed(Message(id: "", content: "", created: Date(), senderID: "", senderName: ""))
                        }

                    }
        }

  
    }

    
    
    public func deleteFromChat(indexPath: IndexPath, completed: @escaping (String)-> (Void)){
        
        guard let usernickName = UserDefaults.standard.string(forKey: UserDefaultKey.userName) else {
            print("deleteFromChat no usernickName")
            return
        }
       
        guard let chatRoomId = mychatRoom[indexPath.row].chatId else {
            return
        }
        
     
        guard let postId = Int(chatRoomId) else { return }
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
                    self.deleteChatRoom(postId: postId)
                    
                    //사람 chatList에서 나가기
                    ChatService.shared.quitChatList(postId: postId)
                    
                    //게시글 삭제
                    PostService.shared.deletePost(postId: postId)
                    completed("OK")
                }else { // 아직 유저 여러명일때
                    // 글쓴이인경우 == users[0]
                    if(users[0] == usernickName){
                        self.alertViewController(title: "나가기 실패", message: "글쓴이인경우 채팅방을 나갈 수 없습니다.", completion: {(response) in
                        })
                        completed("NO")
                    }else {
                        // 글쓴이가 아닌경우 -> 채팅방에서 혼자만 나가기
                        self.deleteUser(postId: postId)
                        ChatService.shared.quitChatList(postId: postId)
                        //nowpeople 감소
                        PostService.shared.nowPeople(postId: postId, num: -1)
                        completed("OK")
                    }
                   
                }
       
            } else {
                print("Document does not exist")
            }
        }

        
        
       
        
    }
    
    public func deleteChatRoom(postId: Int){

        Firestore.firestore().collection("Chats").document("\(postId)").delete(){ err in
            if let err = err {
                self.alertViewController(title: "채팅방 삭제 실패", message: "채팅방이 존재하지 않습니다.", completion: { (response) in })
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
    
    func deleteUser(postId: Int){
        guard let userNickname = UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else {
            print("deleteFromChat no userNickname")
            return
        }
        let document = Firestore.firestore().collection("Chats").document("\(postId)")

        document.updateData([
            "users": FieldValue.arrayRemove(["\(userNickname)"])
        ])
        print("유저 아직 여러명 -> \(userNickname) 유저만 삭제")
        
    }
        
    
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
        if(!mychatRoom.isEmpty) {
            let chatRoomCell = mychatRoom[indexPath.row]
            cell.roomName.text = chatRoomCell.chatRoomName
            let dateString = DateUtil.latestMessageformatDate(chatRoomCell.latestMessage.created)
            print(chatRoomCell.latestMessage.created)
           
            cell.peopleLabel.text =  "\(userCount[indexPath.row])명 참여 중"
            
            if(chatRoomCell.latestMessage.senderName != ""){
                cell.message.text = "\(chatRoomCell.latestMessage.senderName):\(chatRoomCell.latestMessage.content)"
                cell.latestMessageTime.text = dateString
            }else{
                cell.message.text = ""
                cell.latestMessageTime.text = ""
            }
            
            
            if let indexImage =  mychatRoom[indexPath.row].chatImage {
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
            
        }
        
        
        return cell
        
    }
    
    //swipe 하여 채팅방 나가기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "나가기") { (action, view, success) in
            
            //swipe 할 때의 action 정의
            self.alertViewController(title: "채팅방 나가기", message: "채팅방에서 나가시겠습니까?", completion: { (response) in
                if(response == "OK"){
                    self.deleteFromChat(indexPath: indexPath, completed: {(response) in
                        if(response != "NO"){
                            self.mychatRoom.remove(at: indexPath.row)
                            self.alertViewController(title: "나가기 완료", message: "채팅방에서 나갔습니다.", completion: { (response) in })
                        }
                        tableView.reloadData()
                    })
                }
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


//페이징 함수 확장
extension ChatListViewController: PagingTableViewDelegate {

  func paginate(_ tableView: PagingTableView, to page: Int) {
    chatListTableView.isLoading = true
    print("isLoading")
        self.loadData(at: page) { contents in
            self.mychatRoom.append(contentsOf: contents)
            print(contents)
        self.chatListTableView.isLoading = false
            print("isLoading false")
    }
  }

}




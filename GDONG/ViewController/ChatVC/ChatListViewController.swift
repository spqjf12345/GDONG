//
//  ChatListViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit

class ChatListViewController: UIViewController {
    
    var roomName = ["딸기사실분 선착순입니다!어서어서 들어오세요","향수 공동구매 해요!어서어서 들어오세요"]
    var thumnail = ["strawberry.jpg", "perfume.jpg"]
    var latestMessageTime = ["1시간전", "2021.4.28"]
    var message = ["안녕하세요 채팅내용 입니다 이건 마지막 채팅내용이 나타날 자리 입니다.", "1/80"]
    
    private var conversations = [ChatRoom]()

    
    @IBOutlet var chatListTableView: UITableView!
    
    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "ChatListCell", bundle: nil)

        chatListTableView.register(nibName, forCellReuseIdentifier: "chatList")
        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        DatabaseManager.shared.test();
        
        //self.getConversation()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatListTableView.reloadData()
        
    }
    
    private func getConversation() {
        guard let email = UserDefaults.standard.value(forKey: UserDefaultKey.userEmail) as? String else {
            return
        }

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("starting conversation fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        // get all conversation
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] (result) in
                                                    print(result)})
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
//        })
    }

}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        
        cell.roomName.text = roomName[indexPath.row]
        cell.latestMessageTime.text = latestMessageTime[indexPath.row]
        cell.message.text = message[indexPath.row]
        cell.thumbnail.image = UIImage(named: thumnail[(indexPath as NSIndexPath).row])

        cell.roomName.sizeToFit()
        cell.latestMessageTime.sizeToFit()
        cell.message.sizeToFit()
        cell.thumbnail.sizeToFit()
        
        
        return cell
        
    }
    
    //swipe 하여 채팅방 나가기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "나가기") { (action, view, success) in
            
            //swipe 할 때의 action 정의
            self.roomName.remove(at: indexPath.row)
            self.latestMessageTime.remove(at: indexPath.row)
            self.message.remove(at: indexPath.row)
            self.thumnail.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])

        return config
        
    }

    
    //chat 방 들어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chat", sender: nil)
    }
    
}

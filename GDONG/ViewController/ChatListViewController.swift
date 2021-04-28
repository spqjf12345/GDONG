//
//  ChatListViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit

class ChatListViewController: UIViewController {
    
    var roomName = ["딸기사실분 선착 순입니다!","향수 공동구매 해요"]
    var thumnail = ["strawberry.jpg", "perfume.jpg"]
    var latestMessageTime = ["1시간전", "2021년 4월 28일"]
    var participants = ["1/5", "1/80"]

    
    @IBOutlet var chatListTableView: UITableView!
    
    

    override func viewDidLoad() {
        
        let nibName = UINib(nibName: "ChatListCell", bundle: nil)

        chatListTableView.register(nibName, forCellReuseIdentifier: "chatList")
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatListTableView.reloadData()
        
        }

}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        
        cell.roomName.text = roomName[indexPath.row]
        cell.latestMessageTime.text = latestMessageTime[indexPath.row]
        cell.participants.text = participants[indexPath.row]
        cell.thumbnail.image = UIImage(named: thumnail[(indexPath as NSIndexPath).row])
        
        
        return cell
        
    }
    
    
}

//
//  ChatListViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/27.
//

import UIKit

class ChatListViewController: UIViewController {
    
    var lb = ["안녕","헬로"]

    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        
        cell.vtlabel.text = lb[indexPath.row]
        
        return cell
        
    }
    
    
}

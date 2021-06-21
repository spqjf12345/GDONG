//
//  FolloViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/22.
//

import UIKit

class FolloViewController: UIViewController {

    @IBOutlet weak var follotableView: UITableView!
    var userList = [String]()
    var userFollowList = [String]()
    var userFollowingList = [String]()
    
    var dataFrom = "" // follow data or following data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.getUserInfo(completion: { (response) in
            
            self.userFollowList = response.following
            self.userFollowingList = response.followers
            if(self.dataFrom == "following"){
                self.userList = self.userFollowingList
            }else if(self.dataFrom == "followers"){
                self.userList = self.userFollowList
            }
            self.follotableView.reloadData()
        
    })
        follotableView.delegate = self
        follotableView.dataSource = self
    }

}

extension FolloViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    
    
}

//
//  FolloViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/22.
//

import UIKit

class FolloViewController: UIViewController {

    var FilteredList = [String]()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var follotableView: UITableView!
    var userList = [String]()
    var userFollowList = [String]()
    var userFollowingList = [String]()
    
    var dataFrom: String = "" // follow data or following data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dataFrom :\(dataFrom)")
        API.shared.getUserInfo(completion: { (response) in
            
            self.userFollowList = response.following
            self.userFollowingList = response.followers
            print(self.userFollowList)
            print(self.userFollowingList)
            
            
            if(self.dataFrom == "following"){
                self.userList = self.userFollowingList
            }else if(self.dataFrom == "followers"){
                self.userList = self.userFollowList
            }
            self.follotableView.reloadData()
        
    })
        follotableView.delegate = self
        follotableView.dataSource = self
        
        print(self.userList)
       addHeader()
    }
    
    func addHeader(){
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        header.backgroundColor = .systemPink
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = "all \(dataFrom)"
        header.addSubview(headerLabel)
        follotableView.tableHeaderView = header
    }

}

extension FolloViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel!.text = self.userList[indexPath.row]
        print(self.userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

extension FolloViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool { // x 버튼으로 다 지웠을 때
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        self.FilteredList.removeAll()
        for str in userList{
            FilteredList.append(str)
        }
        follotableView.reloadData()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //enter 눌렀을 때
        if searchTextField.text?.count != 0 {
            self.FilteredList.removeAll()
            for str in userList {
                let name = str.lowercased()
                let range = name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    self.FilteredList.append(str)
                }
                
            }
        }
        follotableView.reloadData()
        return true
    }
    
    //textfield가 글자 입력 중일때
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText  = textField.text! + string
        if searchText.count >= 3{
            FilteredList = userList.filter({ (result) -> Bool in
                result.range(of: searchText, options: .caseInsensitive) != nil
            })
        }else {
            FilteredList = userList
        }
       
        follotableView.reloadData()
        return true
    }
    
    
    
    
}

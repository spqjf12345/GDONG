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
    func getFollowingData(){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dataFrom : \(dataFrom)")
        getFollowingData()
        UserService.shared.getUserInfo(completion: { [self] (response) in
            print(response)
            self.userFollowList = response.followers
            self.userFollowingList = response.following
            
            if(self.dataFrom == "팔로잉"){
                self.userList = self.userFollowingList
            }else if(self.dataFrom == "팔로우"){
                self.userList = self.userFollowList
            }
            //print(response.following)
            self.FilteredList = self.userList
            //print(userFollowingList)
            //print(self.userList)
            //print(self.FilteredList)
            self.follotableView.reloadData()
    })
        follotableView.delegate = self
        follotableView.dataSource = self
        textFieldSetting()
        
        follotableView.register(FolloTableViewCell.nib(), forCellReuseIdentifier: FolloTableViewCell.identifier)
        
       addHeader()
    }
    
    
    func addHeader(){
        let header = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 50))
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = " 모든 \(dataFrom)"
        headerLabel
        headerLabel.font = UIFont(name: "모든 \(dataFrom)", size: 15)
        
        header.addSubview(headerLabel)
        follotableView.tableHeaderView = header
    }
    
    func textFieldSetting(){
        searchTextField.delegate = self
        searchTextField.circle()
    }
    
 
    
    func deleteAlertController(deleteName: String ,completion: @escaping ((String) -> Void)){
        
        let alertVC = UIAlertController(title: "\(dataFrom) 삭제", message: "\(deleteName) 님을 친구 리스트에서 삭제하시겠어요?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .default, handler: { _ in
            completion("delete")
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
       
        
    }

}

extension FolloViewController: UITableViewDelegate, UITableViewDataSource, FolloTableViewCellDelegate {
    
    func didTapDeleteButton(cell: FolloTableViewCell) {
        let buttonPosition:CGPoint = cell.convert(CGPoint.zero, to:self.follotableView)
        let indexPath = self.follotableView.indexPathForRow(at: buttonPosition)
        
        //TO DO userName delete
        deleteAlertController(deleteName: self.userList[indexPath![1]], completion: { response in
            if (response == "delete"){
                UserService.shared.userUnfollow(nickName: self.userList[indexPath!.row], completion: { (response) in
                    if(response == true) {
                        self.userList.remove(at: indexPath!.row)
                        self.FilteredList = self.userList
                        self.follotableView.reloadData()
                        //나의 친구 리스트에서도 삭제
                        //unfollow
                        self.alertViewController(title: "삭제 완료", message: "친구 리스트에서 삭제하였습니다", completion: { (response) in
                            if(response == "OK"){
                                
                            }
                        })
                    }
                  
                })
              
                
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FilteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FolloTableViewCell.identifier) as? FolloTableViewCell
        if(dataFrom == "팔로잉"){
            cell?.deleteButton.setTitle("언팔로우", for: .normal)
        }
        cell?.configure(userName: self.FilteredList[indexPath.row])
        cell?.cellDelegate = self
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //get user info server
        guard let getUserProfileVC = self.storyboard?.instantiateViewController(identifier: "getUserProfile") as? GetUserProfileViewController else { return }
        let userNickName = FilteredList[indexPath.row]
        UserService.shared.getUserProfile(nickName: userNickName, completion: { (response) in
            getUserProfileVC.userInfo = response.nickName
            self.navigationController?.pushViewController(getUserProfileVC, animated: true)
        })
        
    }
    
    
}

extension FolloViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool { // x 버튼으로 다 지웠을 때
        print("delete all search Text")
//        searchTextField.resignFirstResponder()
//        searchTextField.text = ""
        self.FilteredList.removeAll()
        self.FilteredList = self.userList
//        for str in userList{
//            FilteredList.append(str)
//        }
        follotableView.reloadData()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //enter 눌렀을 때
        print("enter the search \(textField.text)")
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
        searchTextField.resignFirstResponder()
        follotableView.reloadData()
        return true
    }
    
    //textfield가 글자 입력 중일때
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("while editing \(textField.text)")
        let searchText  = textField.text!
        if searchText.count >= 2{
            self.FilteredList = self.userList.filter({ (result) -> Bool in
                result.range(of: searchText, options: .caseInsensitive) != nil
            })
        }else {
            self.FilteredList = self.userList
        }
       
        follotableView.reloadData()
        return true
    }
    
    
    
    
}

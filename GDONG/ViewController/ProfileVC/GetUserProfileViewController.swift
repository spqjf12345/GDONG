//
//  GetUserProfileViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/29.
//
import UIKit
import CoreLocation
import Foundation

class GetUserProfileViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var userimage: UIImageView!
    @IBOutlet var isSellerBt: UIButton!
    @IBOutlet var followBt: UIButton!
    @IBOutlet var boardTableView: UITableView!
    @IBOutlet var username: UILabel!
    @IBOutlet var userLocation: UILabel!

    var locationManager: CLLocationManager!
    var userInfo = ""
    
    //var userInfo = Users()
    var userBoard = [Board]()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let index = boardTableView.indexPathForSelectedRow else {
            return
        }

        if let detailVC = segue.destination as? DetailNoteViewController {
            detailVC.oneBoard = userBoard[index.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserprofile()
        getUserPost()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        boardTableView.register(nibName, forCellReuseIdentifier: "productCell")

        boardTableView.delegate = self
        boardTableView.dataSource = self
    }

    func getLocation(longitude: Double, latitude: Double) {

        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        print(findLocation)
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(place, error) in
            if let address: [CLPlacemark] = place {
                if let name: String = address.last?.name{
                    print("user Location : \(name)")
                    self.userLocation.text = name
                }
            }
        })

    }

    @IBAction func didTapfollow(sender: UIButton){
        //팔로우버튼 클릭했을때
        print("didTapfollow")
        if(sender.currentTitle == "팔로잉 중"){
            //언팔 로직
            UserService.shared.userUnfollow(nickName: self.userInfo)
            self.unfollowButtonSetting(sender: sender)
        }else {
            // 새롭게 팔로우
            UserService.shared.userFollow(nickName: self.userInfo)
            self.followingButtonSetting(sender: sender)
        }
        
    }
    
    func followingButtonSetting(sender: UIButton) {
        sender.setTitle("팔로잉 중", for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = .systemGray3
    }
    
    func unfollowButtonSetting(sender: UIButton) {
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.setTitle("팔로우 하기", for: .normal)
        sender.backgroundColor = #colorLiteral(red: 0.414729476, green: 0.5849462152, blue: 0.9022548795, alpha: 1)
        
    }
    
    func getUserprofile(){
        UserService.shared.getUserProfile(nickName: "\(userInfo)",completion: {(response) in

            self.username.text = response.nickName
            self.getLocation(longitude: response.location.coordinates[0], latitude: response.location.coordinates[1])
            
            if(response.isSeller == true){
                self.isSellerBt.isHidden = false
            }else {
                self.isSellerBt.isHidden = true
            }


            //user Image
            if(response.profileImageUrl != ""){
                let urlString = Config.baseUrl + "/static/\(response.profileImageUrl)"

                    if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                        self.userimage.sd_setImage(with: myURL)
                }
            }else {
                self.userimage.image = UIImage(systemName: "person.fill")
            }
            
            DispatchQueue.global().async {
                //팔로잉 중인지 확인
                UserService.shared.getUserInfo(completion: { (response) in
                    guard let nickName = UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else {
                        return
                    }
                    let myFollowingList: [String] = response.following
                    let myFollowList: [String] = response.followers
                    if(nickName == self.userInfo){ //본인
                        print("팔로우 확인 중 본인 확인")
                        self.followBt.isHidden = true
                    }
                    else if(myFollowingList.contains(self.userInfo) || myFollowList.contains(self.userInfo)){
                        //팔로잉 중인 상태로 변경
                        self.followingButtonSetting(sender: self.followBt)
                    }
                })
            }
           

    })
    }
    
    func getUserPost(){
        PostService.shared.getauthorPost(start: -1, author: "\(userInfo)", num: 100, completion: {
            response in

            self.userBoard = response!
            
            DispatchQueue.main.async {
                self.boardTableView.reloadData()
            }
        })
    }


}
extension GetUserProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections: Int = 0
        
        if userBoard.count > 0 {
            tableView.separatorStyle = .singleLine
            numberOfSections = userBoard.count
            tableView.backgroundView = nil
        }
        else
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "쓴 글이 존재하지 않습니다."
                noDataLabel.textColor     = UIColor.systemGray2
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell
        guard userBoard.indices.contains(indexPath.row) else { return cell }

        cell.productNameLabel.text = userBoard[indexPath.row].title
        cell.productPriceLabel.text = "\(userBoard[indexPath.row].price ?? 0) 원"
        let date: Date = DateUtil.parseDate(userBoard[indexPath.row].createdAt!)

        cell.timeLabel.text = BuyViewController.ondDayDateText(date: date)

        //categoryButton add
        cell.categoryButton.setTitle(userBoard[indexPath.row].category, for: .normal)

        cell.categoryButton.setTitleColor(UIColor.white, for: .normal)
        cell.categoryButton.backgroundColor = UIColor.darkGray
        cell.categoryButton.layer.cornerRadius = 5
        cell.categoryButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)

        cell.peopleLabel.text = "\(userBoard[indexPath.row].nowPeople ?? 0) / \(userBoard[indexPath.row].needPeople ?? 0)"
        cell.indexPath = indexPath
        let indexImage =  userBoard[indexPath.row].images![0]
            //print("index image \(indexImage)")
            let urlString = Config.baseUrl + "/static/\(indexImage)"

            if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                cell.productImageView.sd_setImage(with: myURL, completed: nil)
            }
        cell.moreButton.isHidden = true

        return cell
    }
    
    // 디테일뷰 넘어가는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detail", sender: nil)
        
    }
}


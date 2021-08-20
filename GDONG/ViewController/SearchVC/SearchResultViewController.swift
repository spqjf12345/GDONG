//
//  SearchResultViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/03.
//

import UIKit
import DropDown
class SearchResultViewController: UIViewController, TableViewCellDelegate {
    
    
    let more_dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.width = 100
        dropDown.dataSource = ["게시글 삭제"]
        return dropDown
    }()
    
    //delete post
    func moreButton(cell: TableViewCell) {
        
        more_dropDown.anchorView = cell.moreButton
        more_dropDown.show()
        more_dropDown.backgroundColor = UIColor.white
        more_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            
            if(index == 0){ // 게시글 삭제
                self.alertWithNoViewController(title: "게시글 삭제", message: "게시글을 삭제하시겠습니까?", completion: {(response) in
                    if(response == "OK"){
                        print("선택한 셀 \(cell.indexPath!)")
                        guard let postId = filteredBoard[cell.indexPath![1]].postid else {
                            print("cant not find postid")
                            return
                        }
                        
                        PostService.shared.deletePost(postId: postId)
                        filteredBoard.remove(at: cell.indexPath![1])
                        DispatchQueue.main.async {
                            FrameTableView.reloadData()
                        }
                        ChatListViewController().deleteChatRoom(postId: postId)
                        
               
                    }
                })
            }
        }
    }
    
    var searchWord = ""
    var categoryWord = ""
    var filteredBoard = [Board]()
    
    
    //headerview for filtering
//    var HeaderView: UIView = {
//        let headerView = UIView()
//        var filterButton = UIButton()
//        filterButton.setTitle(" 검색 필터", for: .normal)
//        filterButton.setImage(UIImage(systemName: "square.fill.text.grid.1x2"), for: .normal)
//        filterButton.tintColor = .black
//        filterButton.setTitleColor(.black, for: .normal)
//        headerView.addSubview(filterButton)
//        filterButton.frame = CGRect(x: 10, y: 0, width: 100, height: 50)
//        filterButton.addTarget(self, action: #selector(didTapFilteringButton), for: .touchUpInside)
//        return headerView
//    }()
    
    @objc func didTapFilteringButton(){
        print("didTapFilteringButton")
        let filteringVC = UIStoryboard.init(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "searchFilter")
        //filteringVC.modalPresentationStyle = .fullScreen
        filteringVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filteringVC, animated: true)

    }
    
    var FrameTableView: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(FrameTableView)
        FrameTableView.dataSource = self
        FrameTableView.delegate = self
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        FrameTableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        FrameTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        FrameTableView.frame = view.bounds
        
        
        print("search word \(searchWord)")
        print("search category \(categoryWord)")
        if(searchWord != ""){
            title = searchWord
            PostService.shared.getSearchPost(start: -1, searWord: searchWord, num: 100, completion: { [self] (response) in
                self.filteredBoard = response
               print(filteredBoard)
                DispatchQueue.main.async {
                    FrameTableView.reloadData()
                }
               
            })
        }else {
            title = categoryWord
            PostService.shared.getCategoryPost(start: -1, category: categoryWord, num: 100, completion: { [self] (response) in
                self.filteredBoard = response
               print(filteredBoard)
                DispatchQueue.main.async {
                    FrameTableView.reloadData()
                }
               
            })
        }
    
        
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: Int = 0
        
        if filteredBoard.count > 0 {
            tableView.separatorStyle = .singleLine
            numberOfSections = 1
            tableView.backgroundView = nil
        }
        else
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "검색어에 관한 글이 존재하지 않습니다."
                noDataLabel.textColor     = UIColor.systemGray2
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
        return numberOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filteredBoard.count)
        return filteredBoard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        guard filteredBoard.indices.contains(indexPath.row) else { return cell }

        cell.productNameLabel.text = filteredBoard[indexPath.row].title
        cell.productPriceLabel.text = "\(filteredBoard[indexPath.row].price ?? 0) 원"
        
        //내가 쓴 글이 아니라면
        if filteredBoard[indexPath.row].email != myEmail {
           cell.moreButton.isHidden = true
            cell.moreButton.isEnabled = false
        }

        let date: Date = DateUtil.parseDate(filteredBoard[indexPath.row].updatedAt!)

        cell.timeLabel.text = BuyViewController.ondDayDateText(date: date)
        
        //categoryButton add
        cell.categoryButton.setTitle(filteredBoard[indexPath.row].category, for: .normal)
       
        cell.categoryButton.setTitleColor(UIColor.white, for: .normal)
        cell.categoryButton.backgroundColor = UIColor.darkGray
        cell.categoryButton.layer.cornerRadius = 5
        cell.categoryButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
        cell.peopleLabel.text = "\(filteredBoard[indexPath.row].nowPeople ?? 0) / \(filteredBoard[indexPath.row].needPeople ?? 0)"
        cell.indexPath = indexPath
        let indexImage =  filteredBoard[indexPath.row].images![0]
        let urlString = Config.baseUrl + "/static/\(indexImage)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                cell.productImageView.sd_setImage(with: myURL, completed: nil)
        }
        
       return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailNoteViewController
        detailVC.oneBoard = filteredBoard[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

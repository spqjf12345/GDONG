//
//  SearchResultViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/03.
//

import UIKit

class SearchResultViewController: UIViewController {
    var searchWord = ""
    var categoryWord = ""
    var filteredBoard = [Board]()
    
    
    var HeaderView: UIView = {
        let view = UIView()
        var filterButton = UIButton()
        filterButton.setTitle("검색 필터", for: .normal)
        view.addSubview(filterButton)
        filterButton.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
        filterButton.setTitleColor(UIColor.black, for: .normal)
        filterButton.addTarget(self, action: #selector(didTapFilteringButton), for: .touchUpInside)
        return view
    }()
    
    @objc func didTapFilteringButton(){
        print("didTapFilteringButton")
        let filteringVC = UIStoryboard.init(name: "SearchFilter", bundle: nil).instantiateViewController(withIdentifier: "searchFilter")
        filteringVC.modalPresentationStyle = .fullScreen
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
        
        HeaderView.frame = CGRect(x: 0, y: 00, width: view.width, height: 50)
        FrameTableView.tableHeaderView = HeaderView
        FrameTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        //filteredBoard = Dummy.shared.oneBoardDummy(model: filteredBoard)
        
        
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
        }
        
        //filteredBoard = filteredBoard.filter{($0.title.lowercased().contains(searchWord)) || ($0.category.lowercased().contains(categoryWord))}
    
        
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filteredBoard.count)
        return filteredBoard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        tableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell


        cell.productNameLabel.text = filteredBoard[indexPath.row].title
        cell.productImageView.image = UIImage(named: filteredBoard[indexPath.row].profileImage)
        cell.productPriceLabel.text = String(filteredBoard[indexPath.row].price)
        
        let date: Date = DateUtil.parseDate(filteredBoard[indexPath.row].createdAt)
        let dateString: String = DateUtil.formatDate(date)
        
        cell.timeLabel.text = dateString
    
        cell.peopleLabel.text = "\(filteredBoard[indexPath.row].nowPeople)/ \(filteredBoard[indexPath.row].needPeople)"

        let indexImage =  filteredBoard[indexPath.row].images[0]
        let urlString = Config.baseUrl + "/static/\(indexImage)"
    
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
           print(myURL)
            cell.productImageView.sd_setImage(with: myURL, completed: nil)
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailNoteViewController
        detailVC.oneBoard = filteredBoard[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

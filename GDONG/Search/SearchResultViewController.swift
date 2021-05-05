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
    var searchHistory = [Array<String>]()
    
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
    }
    
    var FrameTableView: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // view.addSubview(HeaderView)
        view.addSubview(FrameTableView)
        FrameTableView.dataSource = self
        FrameTableView.delegate = self
        
        HeaderView.frame = CGRect(x: 0, y: 00, width: view.width, height: 50)
        FrameTableView.tableHeaderView = HeaderView
        FrameTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        filteredBoard = Dummy.shared.Boards(model: filteredBoard)
        print("search word \(searchWord)")
        print("search category \(categoryWord)")
        if(searchWord != ""){
            title = searchWord
        }else {
            title = categoryWord
        }
        
        filteredBoard = filteredBoard.filter{($0.titleBoard.lowercased().contains(searchWord)) || ($0.categoryBoard.lowercased().contains(categoryWord))}
        FrameTableView.reloadData()
        
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBoard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = filteredBoard[indexPath.row].titleBoard
        return cell
    }
        


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //go to detail view
    }
}

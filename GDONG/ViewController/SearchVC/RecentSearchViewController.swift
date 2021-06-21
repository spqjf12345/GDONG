//
//  RecentSearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/04.
//

import UIKit

class RecentSearchViewController: UITableViewController, RecentSearchTableViewCellDelegate {
    
    //delete button
    func didTapButton(cell: RecentSearchTableViewCell) {
        let buttonPosition:CGPoint = cell.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        searchHistory.remove(at: indexPath![1])
        tableView.reloadData()
    }
    

    var searchHistory = UserDefaults.standard.array(forKey: "historyWord") as? [String] ?? []
    
    var deleteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "xButton"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 30))
            let label = UILabel()
            label.text = "최근 검색"
            label.textColor = UIColor.systemGray
            label.frame = CGRect(x: 20, y: 5, width: 100, height: 30)
            
            let allButton = UIButton()
            allButton.setTitle("전체 삭제", for: .normal)
            allButton.addTarget(self, action: #selector(didTapAlldelete), for: .touchUpInside)
            allButton.setTitleColor(UIColor.systemGray, for: .normal)
            allButton.frame = CGRect(x: 270, y: 5, width: 100, height: 30)
            view.addSubview(label)
            view.addSubview(allButton)
            return view
        }()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .white
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let searchResult = SearchResultViewController()
//        if let index = tableView.indexPathForSelectedRow {
//            searchResult.searchWord = searchHistory[index.row]
//        }
//
//
//    }
    
    @objc func didTapAlldelete(){
        print("searchHistory.removeAll()")
        searchHistory.removeAll()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: Int = 0
        
        if searchHistory.count > 0 {
            tableView.separatorStyle = .singleLine
            numberOfSections = 1
            tableView.backgroundView = nil
        }
        else
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "최근 검색어가 없습니다."
                noDataLabel.textColor     = UIColor.systemGray2
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(RecentSearchTableViewCell.nib(), forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier) as! RecentSearchTableViewCell
        cell.cellDelegate = self
        cell.searchWord.text = searchHistory[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

}




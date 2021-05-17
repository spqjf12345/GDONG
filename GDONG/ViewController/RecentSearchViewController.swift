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
            label.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
            
            let allButton = UIButton()
            allButton.setTitle("모두 보기", for: .normal)
            allButton.addTarget(self, action: #selector(didTapAllSearch), for: .touchUpInside)
            allButton.setTitleColor(UIColor.blue, for: .normal)
            allButton.frame = CGRect(x: 300, y: 0, width: 100, height: 30)
            view.backgroundColor = UIColor.lightGray
            view.addSubview(label)
            view.addSubview(allButton)
            return view
        }()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .white
    }
    
    @objc func didTapAllSearch(){
//        let allSearchVC = RecentSearchAllTableViewController()
//        allSearchVC.historyWord = searchHistory
//
//        allSearchVC.tableView.reloadData()
//
//        navVC.pushViewController(allSearchVC, animated: true)
        //self.present(allSearchVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(RecentSearchTableViewCell.nib(), forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier) as! RecentSearchTableViewCell
        cell.cellDelegate = self
        cell.searchWord.text = searchHistory[indexPath.row]
        cell.configure()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = searchHistory[indexPath.row]
        
        let searchResult = SearchResultViewController()
        searchResult.searchWord = text

        self.navigationController?.pushViewController(searchResult, animated: true)
    }
  
    

}




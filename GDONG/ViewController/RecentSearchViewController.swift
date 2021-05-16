//
//  RecentSearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/04.
//

import UIKit

class RecentSearchViewController: UITableViewController, RecentSearchTableViewCellDelegate {
    
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
        tableView.reloadData()
        print("search history : \(searchHistory)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "최근 검색"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(RecentSearchTableViewCell.nib(), forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier) as! RecentSearchTableViewCell
        cell.cellDelegate = self
        cell.textLabel?.text = searchHistory[indexPath.row]

        return cell
    }
    
    @objc func didTapDeleteButton(){
        print("did tap delete button")
    }
    

}




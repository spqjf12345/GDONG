//
//  RecentSearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/04.
//

import UIKit

class RecentSearchViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "최근 검색"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "최근 검색어1"
        
        return cell
    }
    

}


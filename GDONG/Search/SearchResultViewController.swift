//
//  SearchResultViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/03.
//

import UIKit

// This protocol helps inform MainTableViewController that a suggested search or product was selected.
//protocol SuggestedSearch: class {
//    // A suggested search was selected; inform our delegate that the selected search token was selected.
//    func didSelectSuggestedSearch(token: UISearchToken)
//
//    // A product was selected; inform our delgeate that a product was selected to view.
//    func didSelectProduct(product: Product)
//}

class SearchResultViewController: UITableViewController {
    var searchWord = ""
    var categoryWord = ""
    var filteredBoard = [Board]()

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredBoard = Dummy.shared.Boards(model: filteredBoard)
        print("search word \(searchWord)")
        print("search category \(categoryWord)")
        if(searchWord != ""){
            title = searchWord
        }else {
            title = categoryWord
        }
        
        filteredBoard = filteredBoard.filter{($0.titleBoard.lowercased().contains(searchWord)) || ($0.categoryBoard.lowercased().contains(categoryWord))}
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBoard.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = filteredBoard[indexPath.row].titleBoard
        return cell
    }
        


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

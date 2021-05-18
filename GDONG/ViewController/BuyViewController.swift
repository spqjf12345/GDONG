//
//  BuyViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/05/17.
//

import UIKit

class BuyViewController: UIViewController {
    
    var itemBoard = [Board]()

    @IBOutlet var buyTableView: UITableView!
    
    
    //당겨서 새로고침시 갱신되어야 할 내용
    @objc func pullToRefresh(_ sender: UIRefreshControl) {
        
        self.buyTableView.refreshControl?.endRefreshing() // 당겨서 새로고침 종료
        self.buyTableView.reloadData() // Reload하여 뷰를 비워주기

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let index = buyTableView.indexPathForSelectedRow else {
            return
        }

        if let detailVC = segue.destination as? DetailNoteViewController {
            detailVC.oneBoard = itemBoard[index.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        buyTableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        itemBoard = Dummy.shared.oneBoardDummy(model: itemBoard)
        
        
        buyTableView.delegate = self
        buyTableView.dataSource = self
        
        
        //당겨서 새로고침
        buyTableView.refreshControl = UIRefreshControl()
        buyTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buyTableView.reloadData()
        
        }
    

}

extension BuyViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //segmented control 인덱스에 따른 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemBoard.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell

            cell.productNameLabel.text = itemBoard[indexPath.row].title
            cell.productPriceLabel.text = itemBoard[indexPath.row].price
            cell.timeLabel.text = itemBoard[indexPath.row].date
            
            cell.peopleLabel.text = "\(itemBoard[indexPath.row].nowPeople)/ \(itemBoard[indexPath.row].needPeople)"
            cell.productImageView.image = UIImage(named: itemBoard[(indexPath as NSIndexPath).row].profileImage)

            cell.productNameLabel.sizeToFit()
            cell.productPriceLabel.sizeToFit()
            cell.timeLabel.sizeToFit()
            cell.peopleLabel.sizeToFit()
            
        
       return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detail", sender: nil)
        
    }
    // 디테일뷰 넘어가는 함수
}


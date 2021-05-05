//
//  RecommendViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/05/05.
//

import UIKit

class RecommendViewController: UIViewController {
    
    var recommendProductName = ["여기는 추천글입니다","조회수 순으로 보여집니다"]
    var recommendProductPrice = ["₩3000","₩4000"]
    var recommendTime = ["1시간전","2시간전"]
    var recommendPeople = ["1/30","1/5"]
    var recommendImage = ["cero.jpg","bigapple.jpg"]

    @IBOutlet var recommendTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        recommendTableVIew.register(nibName, forCellReuseIdentifier: "productCell")
        
        
        recommendTableVIew.delegate = self
        recommendTableVIew.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recommendTableVIew.reloadData()
        
        }
    
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendProductName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell
        
        cell.productNameLabel.text = recommendProductName[indexPath.row]
        cell.productPriceLabel.text = recommendProductPrice[indexPath.row]
        cell.timeLabel.text = recommendTime[indexPath.row]
        cell.peopleLabel.text = recommendPeople[indexPath.row]
        cell.productImageView.image = UIImage(named: recommendImage[(indexPath as NSIndexPath).row])
        
        cell.productNameLabel.sizeToFit()
        cell.productPriceLabel.sizeToFit()
        cell.timeLabel.sizeToFit()
        cell.peopleLabel.sizeToFit()
        
        return cell
    }
    
    
}

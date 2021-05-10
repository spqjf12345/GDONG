//
//  MainViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/09.
//

import UIKit

class MainViewController : UIViewController {
    
    var productName = ["공구해요","사과 공구 하실 분"]
    var productPrice = ["₩3000","₩4000"]
    var time = ["1시간전","2시간전"]
    var people = ["1/30","1/5"]
    var image = ["cero.jpg","bigapple.jpg"]
    
    
    var sellproductName: Array<String> = ["초특가 행사 상품! 딸기 팔아요","향수 타임세일!"]
    var sellproductPrice: Array<String> = ["₩5000","₩70000"]
    var selltime: Array<String> = ["10시간전","22시간전"]
    var sellpeople: Array<String> = ["1/300","1/10"]
    var sellimage = ["strawberry.jpg","perfume.jpg"]
    
    
    
    @IBOutlet var search: UIBarButtonItem!
    @IBOutlet var add: UIBarButtonItem!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    //segmented control 연결(버튼 클릭할때마다 reload)
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        tableView.reloadData() 
    }
    
    
    
    //당겨서 새로고침시 갱신되어야 할 내용
    @objc func pullToRefresh(_ sender: Any) {
        
        self.tableView.refreshControl?.endRefreshing() // 당겨서 새로고침 종료
        self.tableView.reloadData() // Reload하여 뷰를 비워주기

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //네비게이션바의 왼쪽에 현위치라벨 적용
        if let navigationBar = self.navigationController?.navigationBar {
            let positionFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            

            let positionLabel = UILabel(frame: positionFrame)
            positionLabel.text = "서울시 강남구"


            navigationBar.addSubview(positionLabel)
        }
        

        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        tableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //당겨서 새로고침
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)


    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        }
    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //segmented control 인덱스에 따른 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var returnValue = 0

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = productName.count
        case 1:
            returnValue = sellproductName.count
        default:
            break
        }

        return returnValue
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell

        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.productNameLabel.text = productName[indexPath.row]
            cell.productPriceLabel.text = productPrice[indexPath.row]
            cell.timeLabel.text = time[indexPath.row]
            cell.peopleLabel.text = people[indexPath.row]
            cell.productImageView.image = UIImage(named: image[(indexPath as NSIndexPath).row])

            cell.productNameLabel.sizeToFit()
            cell.productPriceLabel.sizeToFit()
            cell.timeLabel.sizeToFit()
            cell.peopleLabel.sizeToFit()

        case 1:
            cell.productNameLabel.text = sellproductName[indexPath.row]
            cell.productPriceLabel.text = sellproductPrice[indexPath.row]
            cell.timeLabel.text = selltime[indexPath.row]
            cell.peopleLabel.text = sellpeople[indexPath.row]
            cell.productImageView.image = UIImage(named: sellimage[(indexPath as NSIndexPath).row])

            cell.productNameLabel.sizeToFit()
            cell.productPriceLabel.sizeToFit()
            cell.timeLabel.sizeToFit()
            cell.peopleLabel.sizeToFit()
        default:
            break
        }
        
       return cell

    }
    
    
    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detail", sender: nil)
//
//
//
//
//    }
// 디테일뷰 넘어가는 함수
        
    
}







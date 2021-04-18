//
//  MainViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/09.
//

import UIKit

class MainViewController : UIViewController {
    
    var productName: Array<String> = ["상품1입니다","사과 공구 하실 분"]
    var productPrice: Array<String> = ["₩3000","₩4000"]
    var time: Array<String> = ["1시간전","2시간전"]
    var people: Array<String> = ["1/30","1/5"]
    var image = ["cero.jpg","bigapple.jpg"]
    
    
    @IBOutlet var search: UIBarButtonItem!
    @IBOutlet var add: UIBarButtonItem!
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        if let navigationBar = self.navigationController?.navigationBar {
            let positionFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            

            let positionLabel = UILabel(frame: positionFrame)
            positionLabel.text = "서울시 강남구"


            navigationBar.addSubview(positionLabel)
        }
        //네비게이션바의 왼쪽에 현위치라벨 적용
        

        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        tableView.register(nibName, forCellReuseIdentifier: "productCell")
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        //Do any additional setup after loading the view.

   
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productName.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell

            cell.productNameLabel.text = productName[indexPath.row]
            cell.productPriceLabel.text = productPrice[indexPath.row]
            cell.timeLabel.text = time[indexPath.row]
            cell.peopleLabel.text = people[indexPath.row]
            cell.productImageView.image = UIImage(named: image[(indexPath as NSIndexPath).row])

        
            
            cell.productNameLabel.sizeToFit()
            cell.productPriceLabel.sizeToFit()
            cell.timeLabel.sizeToFit()
            cell.peopleLabel.sizeToFit()
        
            
        
            return cell

        }
    //테이블뷰 설정
    
    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detail", sender: nil)
//
//
//
//
//    }
// 디테일뷰 넘어가는 함수
    
        
       

}




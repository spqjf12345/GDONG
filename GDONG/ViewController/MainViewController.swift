//
//  HomeViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/09.
//

import UIKit

class MainViewController : UIViewController {
    
    var arr1: Array<String> = ["상품1","상품2"]
    var arr2: Array<String> = ["3000","4000"]
    var arr3: Array<String> = ["1시간전","2시간전"]
    var arr4: Array<String> = ["1/4","1/5"]
        
    
    
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
                
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        tableView.register(nibName, forCellReuseIdentifier: "productCell")
        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        //Do any additional setup after loading the view.

   
    }
    
   
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr1.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell

            cell.productNameLabel.text = arr1[indexPath.row]
            cell.productPriceLabel.text = arr2[indexPath.row]
            cell.timeLabel.text = arr3[indexPath.row]
            cell.peopleLabel.text = arr4[indexPath.row]
            cell.productImageView.image = UIImage(named: "apple.jpg")
            //cell.productImageView.sizeToFit()
            return cell

        }

}




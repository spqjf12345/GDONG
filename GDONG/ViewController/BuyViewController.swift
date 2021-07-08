//
//  BuyViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/05/17.
//

import UIKit
import PagingTableView
import SDWebImage


class BuyViewController: UIViewController {
    
   // var itemBoard = [Board]()
    //페이징을 위한 새로운 변수 저장
    var contents = [Board]()
    var profileImage = [UIImage]()

    @IBOutlet var buyTableView: PagingTableView!
    
    
    //페이징을 위한 데이터 가공
    let numberOfItemsPerPage = 2 //지정한 개수마다 로딩

      func loadData(at page: Int, onComplete: @escaping ([Board]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          let firstIndex = page * self.numberOfItemsPerPage
          guard firstIndex < self.contents.count else {
            onComplete([])
            return
          }
          let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.contents.count ?
            (page + 1) * self.numberOfItemsPerPage : self.contents.count
          onComplete(Array(self.contents[firstIndex ..< lastIndex]))
        }
      }
    
    
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
            detailVC.oneBoard = contents[index.row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        buyTableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        //itemBoard = Dummy.shared.oneBoardDummy(model: itemBoard)
        
        buyTableView.delegate = self
        buyTableView.dataSource = self
        buyTableView.pagingDelegate = self
        
        
        //당겨서 새로고침
        buyTableView.refreshControl = UIRefreshControl()
        buyTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PostService.shared.getAllPosts(completion: { (response) in
            self.contents = response
            print("content is \(self.contents)")
        })
        //buyTableView.reloadData()
        
        }
    

}

extension BuyViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //segmented control 인덱스에 따른 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("page count \(contents.count)")
        return contents.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell
        guard contents.indices.contains(indexPath.row) else { return cell }

            cell.productNameLabel.text = contents[indexPath.row].title
            cell.productPriceLabel.text = "\(contents[indexPath.row].price)"
            let date: Date = DateUtil.parseDate(contents[indexPath.row].createdAt)
            let dateString: String = DateUtil.formatDate(date)
            
            cell.timeLabel.text = dateString
        
            cell.peopleLabel.text = "\(contents[indexPath.row].nowPeople)/ \(contents[indexPath.row].needPeople)"

            let indexImage =  contents[indexPath.row].images[0]
            //print("index image \(indexImage)")
            let urlString = Config.baseUrl + "/static/\(indexImage)"
        
            if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
               print(myURL)
                cell.productImageView.sd_setImage(with: myURL, completed: nil)
            }
        
       return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detail", sender: nil)
        
    }
    // 디테일뷰 넘어가는 함수
}

//페이징 함수 확장
extension BuyViewController: PagingTableViewDelegate {

  func paginate(_ tableView: PagingTableView, to page: Int) {
    buyTableView.isLoading = true
    self.loadData(at: page) { contents in
        self.contents.append(contentsOf: contents)
    self.buyTableView.isLoading = false
    }
  }

}


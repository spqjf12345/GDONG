//
//  RecommendViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/05/05.
//

import UIKit
import PagingTableView

class RecommendViewController: UIViewController {
    
   
    var itemBoard = [Board]()
    
    //페이징을 위한 새로운 변수 저장
    var contents = [Board]()
    

    @IBOutlet var recommendTableView: PagingTableView!

    
    //페이징을 위한 데이터 가공
    let numberOfItemsPerPage = 2 //지정한 개수마다 로딩

      func loadData(at page: Int, onComplete: @escaping ([Board]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          let firstIndex = page * self.numberOfItemsPerPage
          guard firstIndex < self.itemBoard.count else {
            onComplete([])
            return
          }
          let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.itemBoard.count ?
            (page + 1) * self.numberOfItemsPerPage : self.itemBoard.count
          onComplete(Array(self.itemBoard[firstIndex ..< lastIndex]))
        }
      }
    
    
    
    
    
    //당겨서 새로고침시 갱신되어야 할 내용
    @objc func pullToRefresh(_ sender: UIRefreshControl) {
        
        self.recommendTableView.refreshControl?.endRefreshing() // 당겨서 새로고침 종료
        self.recommendTableView.reloadData() // Reload하여 뷰를 비워주기

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let index = recommendTableView.indexPathForSelectedRow else {
            return
        }

        if let detailVC = segue.destination as? DetailNoteViewController {
            detailVC.oneBoard = itemBoard[index.row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //headerview 설정
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let headerlabel = UILabel(frame: header.bounds)
        
        headerlabel.text = "Notice:  공감수가 높은순으로 보여집니다."
        headerlabel.textAlignment = .center
        headerlabel.setTextWithLineHeight(text: headerlabel.text, lineHeight: 35)
        headerlabel.layer.cornerRadius = 10
        headerlabel.layer.borderWidth = 1
        headerlabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        let color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let attributedString = NSMutableAttributedString(string: headerlabel.text!)
        attributedString.addAttribute(.foregroundColor, value: color, range: (headerlabel.text! as NSString).range(of:"Notice:"))
        headerlabel.attributedText = attributedString
        
        header.addSubview(headerlabel)
        recommendTableView.tableHeaderView = header
        

        // 테이블뷰와 테이블뷰 셀인 xib 파일과 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)

        recommendTableView.register(nibName, forCellReuseIdentifier: "productCell")
        
        itemBoard = Dummy.shared.oneBoardDummy(model: itemBoard)
        
        recommendTableView.delegate = self
        recommendTableView.dataSource = self
        recommendTableView.pagingDelegate = self
        

        
        //당겨서 새로고침
        recommendTableView.refreshControl = UIRefreshControl()
        recommendTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recommendTableView.reloadData()
        
    }
    
    
    
   
}

extension RecommendViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! TableViewCell
        guard contents.indices.contains(indexPath.row) else { return cell }
            
        cell.productNameLabel.text = contents[indexPath.row].title
        cell.productPriceLabel.text = contents[indexPath.row].price
        //cell.timeLabel.text = contents[indexPath.row].date
        cell.peopleLabel.text = "\(contents[indexPath.row].nowPeople)/ \(contents[indexPath.row].needPeople)"
        //cell.productImageView.image = UIImage(named: contents[(indexPath as NSIndexPath).row].profileImage)
        
        return cell
            
        
        
    }

    
    // 디테일뷰 넘어가는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: nil)
    
    }
    
    
}


//페이징 함수 확장
extension RecommendViewController: PagingTableViewDelegate {

  func paginate(_ tableView: PagingTableView, to page: Int) {
    recommendTableView.isLoading = true
    self.loadData(at: page) { contents in
        self.contents.append(contentsOf: contents)
    self.recommendTableView.isLoading = false
    }
  }

}




//uilabel 확장
extension UILabel {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2
            ]

            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)


            self.attributedText = attrString

        }

    }

}




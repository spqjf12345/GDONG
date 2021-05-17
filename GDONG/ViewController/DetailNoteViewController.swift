//
//  DetailNoteViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//

/// need to add url
/// in progress, .. 단계, 카테고리
import UIKit

class DetailNoteViewController: UIViewController, UIGestureRecognizerDelegate {
    var oneBoard: [Board] = []
    var oneUser: [User] = []
    
    var FrameTableView: UITableView = {
        var table = UITableView()
        table.register(TitleTableViewCell.nib(), forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorColor = UIColor.lightGray
        table.isEditing = false
        table.isScrollEnabled = true
        table.allowsSelection = false
        return table
    }()

    
    var contentTextview: UITextView = {
        var textview = UITextView()
        textview.isUserInteractionEnabled = true
        textview.isSelectable = true
        textview.isEditable = false
        return textview
    }()
    
    var footerView: UIView = {
        var view = UIView()
        return view
    }()
    
    var priceView: UIView = {
        var view = UIView()
        return view
    }()
    
    var bottomView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemYellow
        var goToChatButton = UIButton()
        goToChatButton.setTitle("채팅 방 가기", for: .normal)
        goToChatButton.setTitleColor(UIColor.white, for: .highlighted)
        goToChatButton.backgroundColor = UIColor.orange
        goToChatButton.layer.cornerRadius = 5
        goToChatButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        goToChatButton.addTarget(self, action: #selector(didTapGoToChatRoom), for: .touchUpInside)
        
        view.addSubview(goToChatButton)
        goToChatButton.frame = CGRect(x: 220, y: 20, width: 150, height: 50)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(FrameTableView)
        FrameTableView.frame = view.bounds
        FrameTableView.delegate = self
        FrameTableView.dataSource = self
     
        
        // - dummy data
        oneBoard = Dummy.shared.oneBoardDummy(model: oneBoard)
        oneUser = Dummy.shared.oneUser(model: oneUser)
        
    
        contentTextview.text = "같이 물품 사요! \n 이거 정말 사고 싶었는데 같이 구매하실 분 구해요 \n\n"
        contentTextview.font = .systemFont(ofSize: 30)
        contentTextview.frame = CGRect(x: 10, y: 10, width: view.width - 30, height: view.height - 300)

        priceView.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
        
        let priceLabel = UILabel()
        priceLabel.text = "가격 : \(oneBoard[0].price)원"
        priceLabel.font = .boldSystemFont(ofSize: 20)
        priceView.addSubview(priceLabel)
        priceLabel.frame = CGRect(x: 20, y: 30, width: 150, height: 30)
        
        let needPersonLabel = UILabel()
        needPersonLabel.text = " \(oneBoard[0].nowPeople) /\(oneBoard[0].needPeople) 명"
        needPersonLabel.font = .systemFont(ofSize: 20)
        priceView.addSubview(needPersonLabel)
        needPersonLabel.frame = CGRect(x: view.width - 100 , y: 30, width: 150, height: 30)
        
        
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
       
        let viewCount = UILabel()
        viewCount.text = "조회수 \(oneBoard[0].viewBoard)"
        viewCount.textColor = UIColor.systemGray
        viewCount.frame = CGRect(x: 20, y: 20, width: 100, height: 25)
        
        let interestCount = UILabel()
        interestCount.text = "관심수 \(oneBoard[0].interestBoard)"
        interestCount.textColor = UIColor.systemGray
        interestCount.frame = CGRect(x: viewCount.frame.maxX + 10, y: 20, width: 100, height: 25)
        
        footerView.addSubview(viewCount)
        footerView.addSubview(interestCount)
 
    
    
        
        // navigaion bar - report button
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapReport))
        
        
        view.addSubview(bottomView)
        bottomView.frame = CGRect(x: 0, y: view.bottom - 100, width: view.width, height: 100)
        
        //dummy content data
        makeContentView()
        
        let heartButton = HeartButton(frame: CGRect(x: 50, y: 25, width: 40, height: 40))
            heartButton.addTarget(
              self, action: #selector(didTapHeart(_:)), for: .touchUpInside)
        bottomView.addSubview(heartButton)

    }
    
    
    @objc func didTapReport(){
        //make with dropDown button
    }
    
    @objc func didTapGoToChatRoom(){
        print("didTapGoToChatRoom")
    }
    
    @objc func didTapHeart(_ sender: UIButton){
        print("didTapHeart")
        guard let button = sender as? HeartButton else { return }
        if(button.flipLikedState() == true){
            //관심 글 등록 toast message
            self.showToast(message: "관심 글에 등록되었습니다.", font: .systemFont(ofSize: 12.0))
        }
    }
    

    func makeContentView(){
        let image1Attachment = NSTextAttachment()
        let localImage = UIImage(named: "rabbit")!
        image1Attachment.image = localImage
        
        let newImageWidth = (contentTextview.bounds.size.width - 30)
        let scale = newImageWidth/localImage.size.width
        let newImageHeight = (localImage.size.height - 30) * scale
        image1Attachment.bounds = CGRect.init(x: 0, y: 300, width: newImageWidth, height: newImageHeight)
       
        image1Attachment.image = UIImage(cgImage: (image1Attachment.image?.cgImage!)!, scale: scale, orientation: .up)
        
        let imgString = NSAttributedString(attachment: image1Attachment)
        let combination = NSMutableAttributedString()
        let fontSize = UIFont.boldSystemFont(ofSize: 20)

        let NSMAString = NSMutableAttributedString(string: contentTextview.text)
        NSMAString.addAttribute(.font, value: fontSize, range: (contentTextview.text as NSString).range(of: contentTextview.text))
            
        combination.append(NSMAString)
        combination.append(imgString)
        contentTextview.attributedText = combination
    }
    

}








extension DetailNoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // has four table cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
     
        //titleCell
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as! TitleTableViewCell
            cell.configure(with: oneBoard[0], modelUser: oneUser[0])
            return cell
        }else if(indexPath.row == 1){
            cell.addSubview(contentTextview)
            return cell
        }else if(indexPath.row == 2){
            cell.addSubview(priceView)
           return cell
        }else if(indexPath.row == 3){
            cell.addSubview(footerView)
           return cell
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == FrameTableView){
            if(indexPath.row == 0){ // titleCell
                return 100
            }else if(indexPath.row == 1){ // contentCell
                return view.height - 200
            }else if (indexPath.row == 2){ //price
                return 100
            }else if (indexPath.row == 3){ //footer
                return 200
            }
        }
        return 50 // default
    }
  
    

    
}

class HeartButton: UIButton {
  private var isLiked = false
  
  private let unlikedImage = UIImage(named: "heart_empty")
  private let likedImage = UIImage(named: "heart")
  
  private let unlikedScale: CGFloat = 0.7
  private let likedScale: CGFloat = 1.3

  override public init(frame: CGRect) {
    super.init(frame: frame)

    setImage(unlikedImage, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func flipLikedState() -> Bool {
    isLiked = !isLiked
    animate()
    return isLiked
  }

  private func animate() {
    UIView.animate(withDuration: 0.1, animations: {
      let newImage = self.isLiked ? self.likedImage : self.unlikedImage
      let newScale = self.isLiked ? self.likedScale : self.unlikedScale
      self.transform = self.transform.scaledBy(x: newScale, y: newScale)
      self.setImage(newImage, for: .normal)
    }, completion: { _ in
      UIView.animate(withDuration: 0.1, animations: {
        self.transform = CGAffineTransform.identity
      })
    })
  }
}
 

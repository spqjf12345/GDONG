//
//  DetailNoteViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//


import UIKit
import FirebaseFirestore


//private enum Cells: String, CaseIterable {
//    case TitleTableViewCell
//    case ContentTableViewCell
//    case LinkTableViewCell
//    case PriceAndPeopleTableViewCell
//    case ViewAndLikeTableViewCell
//    case cell
//}


class DetailNoteViewController: UIViewController, UIGestureRecognizerDelegate {
    var oneBoard: Board?
   // private let cellList = Cells.allCases
    
    @IBOutlet weak var FrameTableView: UITableView!

//    var contentTextview: UITextView = {
//        var textview = UITextView()
//        textview.isUserInteractionEnabled = true
//        textview.isSelectable = true
//        textview.isEditable = false
//        return textview
//    }()
//
//    var linkView: UIView = {
//        var view = UIView()
//        return view
//    }()
//
//    var footerView: UIView = {
//        var view = UIView()
//        return view
//    }()
//
//    var priceView: UIView = {
//        var view = UIView()
//        return view
//    }()
    
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
    
    let userNickName = UserDefaults.standard.string(forKey: UserDefaultKey.userNickName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetting()

        //priceView.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
        
//        let priceLabel = UILabel()
//        priceLabel.text = "가격 : \(String(oneBoard!.price))원"
//        priceLabel.font = .boldSystemFont(ofSize: 20)
//        priceView.addSubview(priceLabel)
//        priceLabel.frame = CGRect(x: 20, y: 30, width: 150, height: 30)
//
//        let needPersonLabel = UILabel()
//        needPersonLabel.text = " \(oneBoard!.nowPeople) / \(oneBoard!.needPeople) 명"
//        needPersonLabel.font = .systemFont(ofSize: 20)
//        priceView.addSubview(needPersonLabel)
//        needPersonLabel.frame = CGRect(x: view.width - 100 , y: 30, width: 150, height: 30)
        
        //contentTextview.frame = CGRect(x: 10, y: 10, width: view.width - 30, height: view.height - 300)
//        linkView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
//        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
//
//        let viewCount = UILabel()
//        viewCount.text = "조회수 \(oneBoard!.view)"
//        viewCount.textColor = UIColor.systemGray
//        viewCount.frame = CGRect(x: 20, y: 20, width: 100, height: 25)
//
//        let interestCount = UILabel()
//        interestCount.text = "관심수 \(oneBoard!.interest)"
//        interestCount.textColor = UIColor.systemGray
//        interestCount.frame = CGRect(x: viewCount.frame.maxX + 10, y: 20, width: 100, height: 25)
//
//        footerView.addSubview(viewCount)
//        footerView.addSubview(interestCount)
 
    
    
        
        // navigaion bar - report button
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapReport))
        
        
        view.addSubview(bottomView)
        bottomView.frame = CGRect(x: 0, y: view.bottom - 100, width: view.width, height: 100)
        
        
        let heartButton = HeartButton(frame: CGRect(x: 50, y: 25, width: 40, height: 40))
            heartButton.addTarget(
              self, action: #selector(didTapHeart(_:)), for: .touchUpInside)
        bottomView.addSubview(heartButton)

    }
    
    func tableViewSetting(){
        FrameTableView.register(TitleTableViewCell.nib(), forCellReuseIdentifier: TitleTableViewCell.identifier)
        FrameTableView.register(ContentTableViewCell.nib(), forCellReuseIdentifier: ContentTableViewCell.identifier)
        FrameTableView.register(LinkTableViewCell.nib(), forCellReuseIdentifier: LinkTableViewCell.identifier)
        FrameTableView.register(PriceAndPeopleTableViewCell.nib(), forCellReuseIdentifier: PriceAndPeopleTableViewCell.identifier)
        FrameTableView.register(ViewAndLikeTableViewCell.nib(), forCellReuseIdentifier: ViewAndLikeTableViewCell.identifier)
        FrameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //FrameTableView.rowHeight = UITableView.automaticDimension
        FrameTableView.separatorInset.left = 0

  
        FrameTableView.separatorColor = UIColor.lightGray
        FrameTableView.isEditing = false
        FrameTableView.isScrollEnabled = true
        FrameTableView.allowsSelection = false
        FrameTableView.delegate = self
        FrameTableView.dataSource = self
    }
    
    
    @objc func didTapReport(){
        //make with dropDown button
    }
    
    @objc func didTapGoToChatRoom(){
        print("didTapGoToChatRoom")
        //TO-DO
        //if post user 인원 안찼을 때
        guard let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else {
            print("no exists user ")
            return
        }
        addUserToChat(userEamil: userEmail)
        //else alertController()
        
    }
    
    func addUserToChat(userEamil: String){
        //getPostInfo
        //postId == chatId
        let postId = ""
        let document = Firestore.firestore().collection("Chats").document(postId)
        
        //let users = [userEamil] // 방 생성 시 혼자만 있음
        //let users = [self.currentUser.uid, self.user2UID]
//        let data: [String: Any] = [
//            "users": FieldValue.arrayUnion(["\(userEamil)"])
//        ]
//        document.setData(data){ err in
//            if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//        }
        document.updateData([
            "users": FieldValue.arrayUnion(["\(userEamil)"])
        ])

    }
    
    public func alertController() {
       let AlertVC = UIAlertController(title: "인원 초과", message: "채팅방에 인원이 꽉 찼습니다.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        AlertVC.addAction(OKAction)
        
        self.present(AlertVC, animated: true, completion: nil)
    }
    
    
    @objc func didTapHeart(_ sender: UIButton){
        print("didTapHeart")
        guard let button = sender as? HeartButton else { return }
        if(button.flipLikedState() == true){
            //관심 글 등록 toast message // TO DO post likes
            self.showToast(message: "관심 글에 등록되었습니다.", font: .systemFont(ofSize: 12.0))
        }
    }
    //contentView content
    func makeContentView(contentTextView : UITextView) -> NSAttributedString {
        
        let fullString = NSMutableAttributedString()
        
        if(oneBoard!.content != ""){
            fullString.append(NSAttributedString(string: oneBoard!.content))
            fullString.append(NSAttributedString(string: "\n\n\n\n"))
           
        }
 
        for i in oneBoard!.images {
            let image1Attachment = NSTextAttachment()
            let urlString = Config.baseUrl + "/static/\(i)"

            if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                let data = try? Data(contentsOf: myURL)
                let localImage = UIImage(data: data!)
                image1Attachment.image = localImage
                
                let newImageWidth = (contentTextView.bounds.size.width - 30)
                let scale = newImageWidth/localImage!.size.width
                let newImageHeight = (localImage!.size.height - 30) * scale
                image1Attachment.bounds = CGRect.init(x: 0, y: 300, width: newImageWidth, height: newImageHeight)
               
                image1Attachment.image = UIImage(cgImage: (image1Attachment.image?.cgImage!)!, scale: scale, orientation: .up)
                
                let imgString = NSAttributedString(attachment: image1Attachment)
       
                let fontSize = UIFont.systemFont(ofSize: 15)
                
                
             
                fullString.addAttribute(.font, value: fontSize, range: (contentTextView.text as NSString).range(of: contentTextView.text))
                fullString.append(imgString)
                
            }
        }
        return fullString

    }
        


    }
    




extension DetailNoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nomalCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        //titleCell
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as! TitleTableViewCell
            
            cell.configure(with: oneBoard!, modelUser: userNickName!)
            return cell
            
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier) as! ContentTableViewCell
            print("0 \(cell.contentTextView.height)")
            
            cell.contentTextView.attributedText = makeContentView(contentTextView : cell.contentTextView)
            cell.calculate()
            
            print("2 \(cell.contentTextView.height)")
            return cell
            
        }else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: LinkTableViewCell.identifier) as! LinkTableViewCell
      
            cell.configure(link: oneBoard!.link)
           return cell
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceAndPeopleTableViewCell.identifier) as! PriceAndPeopleTableViewCell
            cell.configure(price: oneBoard!.price, nowPeople: oneBoard!.nowPeople, needPeople: oneBoard!.needPeople)
           return cell
            
        }else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewAndLikeTableViewCell.identifier) as! ViewAndLikeTableViewCell
            cell.configure(view: oneBoard!.view, like: oneBoard!.interest)
    
           return cell
        }else if (indexPath.row == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            return cell
        }
        
        return nomalCell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension // default
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
 


//
//  CreateNewItemViewController.swift
//  GDONG
//
//  Created by Woochan Park on 2021/04/22.
//
import UIKit
import PhotosUI
import Alamofire
import FirebaseFirestore
import CoreLocation

private enum Cells: String, CaseIterable {
  case PhotoCell
  case TitleCell
  case CategoryCell
  case PriceCell
  case EntityCell
}

private enum InvalidValueError: String, Error {
  case invalidPhoto
  case invalidTitle
  case invalidCategory
  case invalidePrice
  case invalidEntity
}

class CreateNewItemViewController: UIViewController {
  
  @IBOutlet private weak var photoCollectionView: UICollectionView!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var toolBar: UIToolbar!
  @IBOutlet weak var photoPickButton: UIButton!
  @IBOutlet weak var photoCountingLabel: UILabel!
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var priceCell: PriceCell! // 값을 두개 가져오기 위해서 이것은 cell 로 가져옴
  @IBOutlet weak var entityTextView: UITextView!
  
  var token: NSObjectProtocol?
    var images: [Data] = []
    var image = Data()
    //var profileImage: String?
    
  
  private let phPickerVC: PHPickerViewController = {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 0
    
    let picker = PHPickerViewController(configuration: configuration)
    return picker
  }()
  
  private var userSelectedPhotoImageList: [UIImage] = [] {
    didSet {
      DispatchQueue.main.async {
        self.photoCollectionView.reloadData()
        self.photoCountingLabel.text = "\(self.userSelectedPhotoImageList.count)/10"
        
      }
    }
  }
    
    func postData(){
        //images data array
        for image in userSelectedPhotoImageList {
            let imageData = image.jpeg(.lowest)
            self.images.append(imageData!)
        }
        
        let locationManager =  CLLocationManager()
        let coor = locationManager.location?.coordinate
        let latitude = coor?.latitude
        let longitude = coor?.longitude
        let location = Location(dictionary: ["coordinates" : [latitude, longitude]])

        //guard let price: Int = Int(self.priceCell.priceTextField.text!) else { return }
        let pricetext = self.priceCell.priceTextField.text!
        let priceCharList = [Character](pricetext.filter { $0 != "," })
        let postprice:Int = Int(String(priceCharList))!
        
        //self.profileImage = images[0].base64EncodedString(options: .lineLength64Characters)
        print("post price \(postprice)")
        
        print(self.titleTextField.text!)
        print(self.entityTextView.text)
        print(postprice)
        print(type(of: postprice))
        print(self.categoryLabel.text!)
        print(self.images)
        print(location)
        
        PostService.shared.uploadPost(title: self.titleTextField.text!, content: self.entityTextView.text, link: "www.naver.com", needPeople: 5, price: postprice, category: self.categoryLabel.text!, images: images, profileImg: "", location: location!, completionHandler: { (response) in
            print(response)
            self.postId = response.postid
            self.image = response.images[0]
        })
            
    }
    
//    //post 코드 완성버전
//    func post() throws {
//
//        let url = Config.baseUrl + "/post/upload"
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data"
//        ]
//
//        var postboard = PostBoard()
//
//        guard let author =  UserDefaults.standard.string(forKey: UserDefaultKey.userNickName) else { return }
//        guard let authorEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else { return }
//
//        var locationManager: CLLocationManager!
//        let coor = locationManager.location?.coordinate
//        let latitude = coor?.latitude
//        let longitude = coor?.longitude
//
//        postboard.author = "test nicname"
//        postboard.title = self.titleTextField.text!
//        postboard.content = self.entityTextView.text
//        postboard.link = "link"
//        postboard.needPeople = "5"
//        guard let price: Int = Int(self.priceCell.priceTextField.text!) else { return }
//        postboard.price = price
//        postboard.category = self.categoryLabel.text!
//
//
//        //콤마 지우고 디비에 저장될 수 있게 해주는코드
//        let pricetext = price
//        let priceCharList = [Character](pricetext.filter { $0 != "," })
//        let postprice = String(priceCharList)
//
//
//        이미지 전송위한 코드
//        let image = UIImage(named: "strawberry.jpg")
//        let imgData = image!.jpegData(compressionQuality: 0.2)! //압축퀄리티 조정 필요
//
//
//
//        AF.upload(multipartFormData: { multipartFormData in do {
//            print("[API] /post/upload 유저 글 쓰기 업데이트")
//            multipartFormData.append(Data(postboard.author!.utf8), withName: "author", mimeType:"text/plain")
//            multipartFormData.append(Data(postboard.title!.utf8), withName: "title", mimeType:"text/plain")
//            multipartFormData.append(Data(postboard.content!.utf8), withName: "content", mimeType:"text/plain")
//            multipartFormData.append(Data(postboard.link!.utf8), withName: "link", mimeType:"text/plain")
//            multipartFormData.append(Data(postboard.needPeople!.utf8), withName: "needPeople", mimeType:"text/plain")
//            multipartFormData.append(Data(postprice.utf8), withName: "price", mimeType:"text/plain")
//            multipartFormData.append(Data(postboard.category!.utf8), withName: "category", mimeType:"text/plain")
//            multipartFormData.append(Data(authorEmail.utf8), withName: "email", mimeType:"text/plain")
//            }
//            이미지추가
//            multipartFormData.append(img, withName: "images", fileName: "\(imgData).jpg", mimeType: "image/jpg")
//
//            if let imageArray = postboard.images {
//                for images in imageArray {
//                    multipartFormData.append(images, withName: "images", fileName: "\(images).jpg", mimeType: "image/jpeg")
//                }
//            }
//
//
//            }, to: url, method: .post, headers: headers).responseJSON { response in
//
//            guard let statusCode = response.response?.statusCode else { return }
//
//                switch statusCode {
//                    case 200:
//                        print("성공")
//
//                    default:
//                        print("\(statusCode)" + "실패")
//                }
//
//            }
//
//        }

  
  /// AllCases of enum `Cells`, the list used as tableview Layout order.
  private let cellList = Cells.allCases
    var postId: Int?
  
  /// MARK: ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    phPickerVC.delegate = self
    
    regitserCells()
    
    token = NotificationCenter.default.addObserver(forName: Notification.Name.UserDidDeletePhotoFromPhotoList, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
      // 더 좋은 방법은 없을까?
      guard let cell = noti.object as? PhotoCollectionViewCell else { return }
      
      for index in 0..<(self?.photoCollectionView.visibleCells.count)! {
        if cell === self?.photoCollectionView.visibleCells[index] {
          
          let cellIndexPath = self?.photoCollectionView.indexPathsForVisibleItems[index]
          self?.userSelectedPhotoImageList.remove(at: (cellIndexPath?.item)!)
        }
      }
    })
  }
  
  deinit {
    NotificationCenter.default.removeObserver(token as Any)
  }
  
  @IBAction func backToPreviousView(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func userDidFinishedWriting(_ sender: Any) {
    
    do {
      try validateWriting()
        try postData()
      
      //TODO: Post Function
      //make new chat room
      self.createNewChat()

      
      dismiss(animated: true, completion: nil)
    } catch {
      print(error)
      
      presentAlert(with: error as! InvalidValueError)
    }
  }
    
    func createNewChat() {
        print("createNewChat called")
        guard let myEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail) else{
            print("there are no email")
            return
        }
        
        guard let postId:Int = self.postId else { return }
        
        let users = [myEmail] // 방 생성 시 혼자만 있음
        //let users = [self.currentUser.uid, self.user2UID]
        let data: [String: Any] = [
            "users": users,
            "ChatRoomName" : titleTextField.text!, // 채팅 방 이름
            "Date" : Date(), // 채팅방 생성 날짜
            "PostID" : postId
        ]
        
        let db = Firestore.firestore().collection("Chats")
        
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                ChatListViewController().loadChat()
            }
        }
    }
    

  
  // 유효한 글인지 검사하는 메서드
  private func validateWriting() throws {
    
    if userSelectedPhotoImageList.isEmpty {
      throw InvalidValueError.invalidPhoto
    }
    
    guard let text = titleTextField.text, text.count > 0 else {
      throw InvalidValueError.invalidTitle
    }
    
    guard categoryLabel != nil else {
      throw InvalidValueError.invalidCategory
    }
    
    guard let priceText = priceCell.priceTextField.text, !priceText.isEmpty else {
      throw InvalidValueError.invalidePrice
    }
    
    // price charater list without ','(comma)
    let priceCharList = [Character](priceText.filter { $0 != "," })
    
    for char in priceCharList {
      if !char.isNumber {
        throw InvalidValueError.invalidePrice
      }
    }
    
    /// 글을 아무것도 작성하지 않을 시, lighgray 색상으로 placeholer text 가 채워진다.
    guard let entityTextField = entityTextView, entityTextField.textColor != .lightGray else {
      throw InvalidValueError.invalidEntity
    }
    
  }
  
  fileprivate func presentAlert(with error: InvalidValueError) {
    
    let alert = UIAlertController(title: "비어있는 곳들을 채워주세요🥺", message: error.rawValue , preferredStyle: .alert)
    
    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  /// Register cells in View Controller
  func regitserCells() {
    
    cellList.forEach {
      let cellNib = UINib(nibName: $0.rawValue, bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: $0.rawValue)
    }
  }
  
  @objc func presentPHPicker() {
    
    present(phPickerVC, animated: true, completion: nil)
  }
  
  @objc func deletePhotoFromPhotoList() {
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "CategorySegue" {
      guard let categoryTableVC = segue.destination as? CategoryTableViewController else {
        return
      }
      categoryTableVC.previousVC = self
      categoryTableVC.modalPresentationStyle = .fullScreen
    }
  }
  
}

extension CreateNewItemViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let reuseIdentifier = cellList[indexPath.row].rawValue
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    switch Cells(rawValue: reuseIdentifier) {
      case .PhotoCell:
        if let cell = cell as? PhotoPickerCell {
          cell.imagePickerButton.addTarget(self, action: #selector(presentPHPicker), for: .touchUpInside)
          self.photoCountingLabel = cell.photoCountingLabel
          
          self.photoCollectionView = cell.collectionView
          
          cell.collectionView.dataSource = self
          cell.collectionView.delegate = self
          
          return cell
        }
        
      case .TitleCell:
        if let cell = cell as? TitleCell {
          self.titleTextField = cell.titleTextField
          
          return cell
        }
        
      case .CategoryCell:
        if let cell = cell as? CategoryCell {
          self.categoryLabel = cell.categoryLabel
          
          return cell
        }
          
      case .PriceCell:
        if let cell = cell as? PriceCell {
          self.priceCell = cell
          
          return cell
        }
        
      case .EntityCell:
        if let cell = cell as? EntityCell {
          cell.textView.delegate = self
          self.entityTextView = cell.textView
          return cell
        }
          
      default:
        break
    }
    
    return cell
  }
}

extension CreateNewItemViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // EnticyCell 일때
    // cellForRow(at:) 사용 불가. 아직 cell 들이 초기화 되어있지 않음
    if indexPath.row == cellList.count - 1 {
      return 300
    }
    
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let selectedCell = tableView.cellForRow(at: indexPath) else { fatalError("\(#function)") }
    
    let cellName = selectedCell.reuseIdentifier!
    
    switch Cells(rawValue: cellName) {
    case .CategoryCell:
      performSegue(withIdentifier: "CategorySegue", sender: self)
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

extension CreateNewItemViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .lightGray {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    guard !textView.text.isEmpty else {
      EntityCell.setPlaceHolderText(with: textView)
      return
    }
  }
}

extension CreateNewItemViewController: PHPickerViewControllerDelegate {
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
    //변수 설정 by lys
    var postImageBoard = PostBoard()
    
    dismiss(animated: true)
    guard !results.isEmpty else { return }
    
    results.forEach { (pickerResult) in
      
      if self.userSelectedPhotoImageList.count == 10 { return }
      let itemProvider = pickerResult.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
          
          if let image = image as? UIImage {
            self?.userSelectedPhotoImageList.append(image)
          }
            //post 용 이미지 코드
            if let postimage = image as? Data {
                postImageBoard.images.append(postimage)
            }
        }
      }
    }
  }
}

extension CreateNewItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userSelectedPhotoImageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
      return UICollectionViewCell()
    }

    item.imageView.image = userSelectedPhotoImageList[indexPath.item]
    item.backgroundColor = .systemRed
    
    return item
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("\(#function)")
  }
}

extension CreateNewItemViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let height = Double(collectionView.bounds.height)
    let width = height
    
    return CGSize(width: width, height: height)
  }

}

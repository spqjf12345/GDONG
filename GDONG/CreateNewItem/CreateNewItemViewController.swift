//
//  CreateNewItemViewController.swift
//  GDONG
//
//  Created by Woochan Park on 2021/04/22.
//

import UIKit
import PhotosUI

private enum Cells: String, CaseIterable {
  case PhotoCell
  case TitleCell
  case CategoryCell
  case PriceCell
  case EntityCell
}

private enum InvalidValueError: Error {
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

  
  /// AllCases of enum `Cells`, the list used as tableview Layout order.
  private let cellList = Cells.allCases
  
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
      
      //TODO: Post Function
      print("somePostFunction()")
      
      dismiss(animated: true, completion: nil)
    } catch {
      presentAlert(with: error)
    }
  }
  
  /// 글 유효성 검사
  private func validateWriting() throws {
    
    //TODO: ADD Photo Validation
    
    guard let text = titleTextField.text, text.count > 0 else {
      throw InvalidValueError.invalidTitle
    }
    
    guard categoryLabel != nil else {
      throw InvalidValueError.invalidCategory
    }
    
    guard let priceText = priceCell.priceTextField.text, Int(priceText.filter{ $0 != ","})! > 0 else {
      throw InvalidValueError.invalidePrice
    }
    
    /// 글을 아무것도 작성하지 않을 시, lighgray 색상으로 placeholer text 가 채워진다.
    guard let entityTextField = entityTextView, entityTextField.textColor != .lightGray else {
      throw InvalidValueError.invalidEntity
    }
    
  }
  
  func presentAlert(with error: Error) {
    
    guard error is InvalidValueError else { assertionFailure(#function); return }
    
    let alert = UIAlertController(title: "비어있는 곳들을 채워주세요🥺", message: nil, preferredStyle: .alert)
    
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

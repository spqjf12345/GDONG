//
//  MainViewController.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/09.
//

import UIKit
import Tabman
import Pageboy

class MainViewController : TabmanViewController {
    
    @IBOutlet var search: UIBarButtonItem!
    
    @IBOutlet var add: UIBarButtonItem!
    
    var itemBoard = [Board]()
    
    //view array
    private var viewControllers: Array<UIViewController> = []
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchViewController {
            
        }
        
//        guard let index = .indexPathForSelectedRow else {
//            return
//        }
//
//        if let detailVC = segue.destination as? DetailNoteViewController {
//            detailVC.oneBoard = itemBoard[index.row]
//        }
        
//        if let createItemVC = segue.destination as? CreateNewItemViewController {
//            navigationController?.navigationBar.isHidden = true
//        }
//
      
        
        
      
    }
    
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "searchButton", sender: self)
    }
    
    @IBAction func add(_ sender: Any) {
        let createItemVC = UIStoryboard.init(name: "CreateNewItem", bundle: nil).instantiateViewController(withIdentifier: "CreateNewItemViewController")
        createItemVC.modalPresentationStyle = .fullScreen
        self.present(createItemVC, animated: true, completion: nil)
        
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
  
        //네비게이션바 왼쪽에 현재 위치
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "서울시 강남구", style: .plain, target: self, action: nil)
        
        itemBoard = Dummy.shared.oneBoardDummy(model: itemBoard)
        
//        if let navigationBar = self.navigationController?.navigationBar {
//            let positionFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
//
//
//            let positionLabel = UILabel(frame: positionFrame)
//            positionLabel.text = "서울시 강남구"
//
//
//            navigationBar.addSubview(positionLabel)
//        }
    
        
        //view array에 추가
        let buyViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        let sellViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellViewController") as! SellViewController
        
                
        viewControllers.append(buyViewController)
        viewControllers.append(sellViewController)
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit

        // Add to view
        addBar(bar, dataSource: self, at: .top)


    }
    
}

extension MainViewController : PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        
        switch index {
        case 0:
            item.title = "구매글"
        case 1:
            item.title = "판매글"
        default:
            break
        }
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}







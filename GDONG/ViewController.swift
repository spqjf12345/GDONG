//
//  ViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/04.
//

import UIKit

class ViewController: UIViewController {

    private let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("click search", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        view.backgroundColor = .white
        view.addSubview(nextButton)
        auto_layout()
        //nextButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)

    }
    func auto_layout(){
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    @objc func didTapNextButton(){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }



}

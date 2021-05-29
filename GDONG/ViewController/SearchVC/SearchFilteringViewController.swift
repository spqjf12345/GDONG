//
//  SearchFilteringViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/26.
//

import UIKit
import DLRadioButton

class SearchFilteringViewController: UIViewController, UITextFieldDelegate {

    var setButtton: String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var recentRadioButton: DLRadioButton!
    
    @IBOutlet weak var viewRadioButton: DLRadioButton!
    
    @IBOutlet weak var heartRadioButton: DLRadioButton!
    
    
    @IBOutlet weak var startPriceTextfield: UITextField!
    
    @IBOutlet weak var endPriceTextfield: UITextField!
    
    @IBOutlet weak var kmTextLabel: UILabel!
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {

            self.view.endEditing(true)

        }

    
   
    @IBOutlet weak var radiusSlide: UISlider!
    
    @IBAction func initial(_ sender: Any) {
        uiSetting()
    }
    
    
    @IBAction func done(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startPriceTextfield.delegate = self
        endPriceTextfield.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1

        singleTapGestureRecognizer.isEnabled = true

        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        radiusSlide.addTarget(self, action: #selector(onChangeValueSlider(sender:)), for: .valueChanged)


        uiSetting()
        

       

    }
    
    func uiSetting(){
        radiusSlide.minimumValue = 0
        radiusSlide.maximumValue = 5
        radiusSlide.value = 2.5
        recentRadioButton.isSelected = true
        viewRadioButton.isSelected = false
        heartRadioButton.isSelected = false
        startPriceTextfield.text = "0"
        endPriceTextfield.text = ""
    }
    
    @objc func onChangeValueSlider(sender: UISlider){
        if(sender.value != 0){
            let roundedNum = round(sender.value * 100) / 100
            kmTextLabel.text = "동네 범위 (\(roundedNum)KM)"
            
        }
        
    }
    

    

    

   

}

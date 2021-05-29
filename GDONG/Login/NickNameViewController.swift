//
//  NickNameViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/28.
//

import UIKit

class NickNameViewController: UIViewController {

    @IBOutlet weak var nickNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func nextButton(_ sender: Any) {
        if(nickNameTextfield.text != nil){
            //dp에 저장된 이름이 있으면
            //다시 입력해주세요 alert view 띄우기
            //post nickname
            let LocationVC = UIStoryboard.init(name: "AdditionalInfo", bundle: nil).instantiateViewController(withIdentifier: "location")
            
            self.navigationController?.pushViewController(LocationVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

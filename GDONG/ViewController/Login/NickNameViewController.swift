//
//  NickNameViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/28.
//

import UIKit

class NickNameViewController: UIViewController {

    @IBOutlet weak var nickNameTextfield: UITextField!
    var nickName = ""
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let LocationVC = segue.destination as! LocationViewController
           LocationVC.nickName = nickNameTextfield.text!
       }
       

       @IBAction func nextButton(_ sender: Any) {
           if(nickNameTextfield.text != ""){
               //dp에 저장된 이름이 았으면
            
            
            API.shared.updateNickname(nickName: nickNameTextfield.text!, completion: { (response) in
                print("업데이트 완료 \(response)")
                UserDefaults.standard.setValue(response, forKey: UserDefaultKey.userNickName)
            })
        
               //다시 입력해주세요 alert view 띄우기

               performSegue(withIdentifier: "location", sender: nil)
           }else{
               let alertVC = UIAlertController(title: "닉네임 입력", message: "닉네임을 입력해주세요", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alertVC.addAction(okAction)
               self.present(alertVC, animated: true, completion: nil)
               
           }
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

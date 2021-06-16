//
//  detailLocationViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/05/29.
//

import UIKit
import Alamofire

class detailLocationViewController: UIViewController {

    var searchKeyword = ""
    var jusoResult: [JusoResults] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextfield: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTextfield.text = searchKeyword
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchWithJuso()
      
        
    }
    
    func searchWithJuso(){
        if !searchKeyword.isEmpty {
            findAddress(keyword: searchKeyword){ [weak self]
                (jusoResponse) in
                guard let self = self else { return }
                if(!jusoResponse.results.juso.isEmpty){
                    //print(jusoResponse.results.common)
                    for i in jusoResponse.results.juso {
                        self.jusoResult.append(JusoResults(common: jusoResponse.results.common, juso: [Juso(roadAddr: i.jibunAddr, jibunAddr: i.roadAddr)]))
                        print(self.jusoResult)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }


        }
    }
    
    private func findAddress(keyword: String, completion: @escaping ((JusoResponse) -> Void)){
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        
        let parameters: [String: Any] = ["confmKey": "devU01TX0FVVEgyMDIxMDUzMDAxMDMzNzExMTIyMjE=",
                                                    "currentPage": "1",
                                                    "countPerPage":"10",
                                                    "keyword": searchKeyword,
                                                    "resultType": "json"]
    
        AF.request(url, method: .get, parameters: parameters).responseJSON{ [weak self] (response) in
            guard let self = self else { return }
            if let value = response.value {
                if let jusoResponse: JusoResponse = self.toJson(object: value) {
                    completion(jusoResponse)
                    }else {
                        print("serialize error")
                    }
            }
        }
    }
        
    private func toJson<T: Decodable>(object: Any) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
                    let decoder = JSONDecoder()
                    
                    
                    if let result = try? decoder.decode(T.self, from: jsonData) {
                        return result
                    } else {
                        return nil
                    }
                } else {
                  return nil
                }

    }
    
    func alertController(juso: String, completion: @escaping ((String) -> Void)){
        let alertVC = UIAlertController(title: "현재 위치 확인", message: "\(juso)를 현재 위치로 설정하시겠습니까?", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
           completion("OK")
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationVC = segue.destination as! LocationViewController
        let index = tableView.indexPathForSelectedRow
        locationVC.getLocation = jusoResult[index!.row].juso[0].jibunAddr
        
    }
        
}



extension detailLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jusoResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(JusoTableViewCell.nib(), forCellReuseIdentifier: JusoTableViewCell.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: JusoTableViewCell.identifier) as! JusoTableViewCell

        cell.jibun.text = jusoResult[indexPath.row].juso[0].jibunAddr
        cell.doro.text = jusoResult[indexPath.row].juso[0].roadAddr

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = jusoResult[indexPath.row].juso[0].jibunAddr else { return }
        alertController(juso: text, completion: {
            ok in
            if(ok == "OK"){
                self.performSegue(withIdentifier: "goback", sender: nil)
                
            }
            })
        }
    
    
    
}
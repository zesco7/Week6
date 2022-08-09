//
//  ViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var blogList: [String] = []
    var cafeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*어떤 함수가 먼저 호출될지 알 수 없다.
         //만약 순서대로 네트워크에 요청하고 싶다면?
         

         */
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(#function, "START")
        searchBlog()
    
        print(#function, "END")
        
    }

    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            print(json)
            
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue)
            }
            
            self.searchCafe()
        }
        
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            print(json)
            
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: ""))
            }
            print(self.blogList)
            print(self.cafeList)
            
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return blogList.count
        }
        return cafeList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kakaoCell.identifier, for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        cell.testLabel.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

class kakaoCell: UITableViewCell {
    static let identifier = "kakaoCell"
    @IBOutlet weak var testLabel: UILabel!
    
}

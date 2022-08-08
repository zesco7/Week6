//
//  KakaoAPIManager.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//
//
import Foundation

import Alamofire
import Kingfisher
import SwiftyJSON

class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    private init() {}

    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        AF.request(url, method: .get, headers: header ).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)

            case .failure(let error):
                print(error)
            }
        }
    }
}

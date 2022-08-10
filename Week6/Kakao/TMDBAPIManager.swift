//
//  TMDBAPIManager.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/10.
//

import Foundation

import Alamofire
import Kingfisher
import SwiftyJSON
import UIKit

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() {}
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"

    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function)
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                var stillArray : [String] = []

                for list in json["episodes"].arrayValue {
                    let value = list["still_path"].stringValue
                    stillArray.append(value)
                }
                print(stillArray)
                //dump(stillArray)//print vs dump : dump는 계층구조를 보여줌
                //let still = json["episodes"][0]["still_path"].stringValue
                //print(still)
                
                //고차함수 사용
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                completionHandler(value)

            case .failure(let error):
                print(error)
            }
        }
    }
    /*
    아 그 저는 func callRequest(query: Int, complitionHandler: @escaping ([String]) -> ())
    여기에서 컴플리션핸들러 형태를 바꿔서 해결했어요.
    [String] -> () 이 형태가 아니었어서 괄호 안에 부분만 변경했습니다!!
    */
    
    func requestImage(completionHandler: @escaping ([[String]]) -> () ) {
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//    func requestEpisodeImage() {
//        let id = tvList[7].1
//
//        //반복문으로 해결하면 안 됨. -> 1. 순서보장 안됨 2. 언제 끝날지 모름 3. 제한있을수 있음(1초에 5번 이상 요청시 block)
//
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
//
//        TMDBAPIManager.shared.callRequest(query: id) { stillPath in
//            print(stillPath)
//            TMDBAPIManager.shared.callRequest(query: id) { stillPath in
//                print(stillPath)
//        }
//
//    }

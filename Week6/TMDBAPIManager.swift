//
//  TMDBAPIManager.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/10.
//

import Foundation
import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

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
                print(json)
                
                //let still = json["episodes"][1]["still_path"].stringValue
                //print(still)
               
                var stillArray : [String] = []

                for list in json["episodes"].arrayValue {
                    let value = list["still_path"].stringValue
                    stillArray.append(value)
                }
                
                //고차함수 사용
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                completionHandler(value)
                
                /*print vs dump : dump는 계층구조를 보여줌(튜플처럼 복합적인 데이터를 다룰 때 활용 가능)
                 print(stillArray)
                 dump(stillArray)
                 dump(self.tvList)
                 */
                
                //let still = json["episodes"][0]["still_path"].stringValue
                //print(still)
          
            case .failure(let error):
                print(error)
            }
        }
    }

    //네트워크 통신 응답을 순차적으로 받기 위해서는 응답requestEpisodeImage함수가 아니라 requestImage처럼 클로저내에서 네트워크 통신 구문 써야함(그러면 상위 통신 종료 후 하위 통신 실행)
    //반복문으로 해결하면 안 됨. -> 1. 순서보장 안됨(여러 데이터를 요청해도 응답이 순차적으로 오지 않음) 2. 언제 끝날지 모름(응답이 언제 올지 모름) 3. 제한있을수 있음(ex. 1초에 5번 이상 요청시 block)
    //async/awake(ios13이상 비동기 구문) 통해 중괄호 많이 쓰지 않고도 처리할 수 있음.

    func requestImage(completionHandler: @escaping ([[String]]) -> () ) {
        var posterList: [[String]] = []

        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in //클로저 구문 내에 있으면 구분 지어야 하기 때문에 어떤 인스턴스에 속해있는 튜플인지 가지고 와야해서 .self 추가
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
    /*
    func requestEpisodeImage() {
        let id = tvList[7].1

        
        for item in tvList {
            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
                print(stillPath)
            }
        }

        TMDBAPIManager.shared.callRequest(query: id) { stillPath in
            print(stillPath)
            TMDBAPIManager.shared.callRequest(query: id) { stillPath in
                print(stillPath)
        }
    }
    }
    */


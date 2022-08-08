//
//  URL+Extension.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import Foundation

enum URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}

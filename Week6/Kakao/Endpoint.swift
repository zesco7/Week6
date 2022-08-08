//
//  Endpoint.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}

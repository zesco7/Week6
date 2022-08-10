//
//  ReusableViewProtocol.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/10.
//

import UIKit

//저장 프로퍼티이든 연산프로퍼티 이든 상관없다.
protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get }
}

//익스텐션이기 때문에 저장프로퍼티를 사용할 수 없어서 연산프로퍼티로 사용함
extension UICollectionViewCell: ReusableViewProtocol { 
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

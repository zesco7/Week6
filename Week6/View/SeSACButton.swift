//
//  SeSACButton.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

//@IBDesignable: 인터페이스 빌더 컴파일 시점에서 실시간으로 객체속성 확인할 수 있음
@IBDesignable class SeSACButton: UIButton {
    
    //@IBInspectable : 스토리보드 상에 인스펙터에 해당하는 메뉴 나오게 하는 속성
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth}
        set { layer.borderWidth = newValue}
    }
    @IBInspectable var borderColor: UIColor {
            get { return UIColor(cgColor: layer.borderColor!)}
        set { layer.borderColor = newValue.cgColor}
        }
    }

/*버튼 테마 구현
Swift Attribute: @IBDesignable, @objc, @escaping 등
 
 IBInspectable : 스토리보드 상에 인스펙터에 해당하는 메뉴 나오게 하는 속성
 */

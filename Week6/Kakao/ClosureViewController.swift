//
//  ClosureViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

class ClosureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        
            showAlert(title: "컬러피커", message: "띄우실래요?", okTitle: "띄우기") {
                let picker = UIColorPickerViewController() // uifontpickerviewcontroller
                self.present(picker, animated: true)
            }
    }
    
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기", okAction: {
            
        })
    }
    
}

//클로저 사용시 @escaping 써줘야함
extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> () ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            
            okAction()
            print(action.title)
            self.view.backgroundColor = .gray
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

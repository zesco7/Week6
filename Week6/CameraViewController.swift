//
//  CameraViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker

//빌드할 때 권한 전부 허용하기
class CameraViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    //UIImagePickerController1. : 사진관리 인스턴스 선언
    let picker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //UIImagePickerController2. : 프로토콜 연결
        picker.delegate = self
        
        
    }
    //open source
    //권한 문구 등도 YPImagePicker 내부에 구현되어있음. 실제로 카메라를 사용할 때 마이크 등 권한 요청함.(앱을 켰을때가 아님)
    //현재는 카메라 "한번만 허용" 설정은 없음
    @IBAction func YPImagePickerButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    
    //UIImagePickerController
    //카메라 사용기기인지 판단(isSourceTypeAvailable(.camera)) *리미티드 에디션처럼 카메라 없는 아이폰도 있다고 함.
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트 또는 얼럿 알림")
            return
        }
        
        picker.sourceType = .camera //.photoLibrary면 갤러리 뜸
        picker.allowsEditing = false // false이면 사진촬영 후 편집화면 안나옴
        
        present(picker, animated: true)
    }
    
    
    //UIImagePickerController
    @IBAction func photoLIbraryButton(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트 또는 얼럿 알림")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false // false이면 사진촬영 후 편집화면 안나옴
        
        present(picker, animated: true)
    }
    
    
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        //resultImageView에 사진이 있으면 저장할 수 있음(UIImageWriteToSavedPhotosAlbum)
        print(#function)
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    }
    
    /*
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "tfYqqDDQUPRUW3CIm5x4",
            "X-Naver-Client-Secret": "NAoG26YRAW",
            "Content-Type": "multipart/form-data"
        ]
        
        
        //uiimage를 텍스트 형태로 변환해서 전달
        //문자열과 다르게 파일, 이미지, pdf 등은 파일 자체가 그대로 전송되지 않기 때문에 텍스트형태로 인코딩하여 전송함.
        //서버에 전송되는 파일 종류를 명시 : Content-Type(콘텐트 타입은 라이브러리에 포함되어 있기 때문에 생략해도 됨)
        guard let imageData = resultImageView.image?.pngData() else { return }
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data("one".utf8), withName: "image")
            }, to: url, headers: header)
            .validate(statusCode: 200..<400).responseData { response in
                        
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            
                        case .failure(let error):
                            print(error)
                        }
    }
    
    
}
}
*/
}


//UIImagePickerController3. : 프로토콜 선언
//네비게이션 컨트롤러를 상속받기 때문에 익스텐션에서 위임받아야함.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UIImagePickerController4. : 뷰 기능 사용시(didFinishPickingMediaWithInfo: 사진을 선택 또는 카메라 촬영 직후 실행)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //infokey: 원본, 편집, 메타 데이터 등
        //편집된 이미지 정보가 UIImage형식이 맞다면 image프로퍼티 값이 된다.
        //피커의 소스타입에 따라 다른 값을 가져오고 싶다면 조건문 사용 가능(picker.sourceType == .camera {})
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
    }
     
    //UIImagePickerController5. : 취소 버튼 클릭시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
}


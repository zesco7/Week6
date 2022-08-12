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

//권한 전부 허용하기
class CameraViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    //UIImagePickerController1.
    let picker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //UIImagePickerController2.
        
        
    }
    //open source
    
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
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트 또는 얼럿 알림")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = true // false이면 사진촬영 후 편집화면 안나옴
        
        present(picker, animated: true)
    }
    
    //UIImagePickerController
    @IBAction func photoLIbraryButton(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트 또는 얼럿 알림")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // false이면 사진촬영 후 편집화면 안나옴
        
        present(picker, animated: true)
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImageView.image {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    }
    
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




//UIImagePickerController3.
//네비게이션 컨트롤러를 상속받기 때문에 익스텐션에서 위임받아야함.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UIImagePickerController4. : 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //infokey: 원본, 편집, 메타 데이터 등
        
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


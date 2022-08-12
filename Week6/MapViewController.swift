//
//  MapViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/11.
//

import UIKit
import MapKit
import CoreLocation


/*위치
 1. import CoreLocation
 2. let locationManager = CLLocationManager() //
 3. locationManager.delegate = self , extension MapViewController: CLLocationManagerDelegate // 프로토콜 연결 및 선언
 4. 위치정보 가져오기 성공여부에 따른
 5. extension MapViewController // 위치와 관련된 User Defined 메서드
 */

/*
 MapView
 -. 지도와 위치권한은 상관없다. 불러온 지도에 현재위치를 표시하려면 위치 권한을 등록해줘야 한다.
 -. 디폴트 위치와 범위를 지정해줘야 한다.
 -. 핀을 추가해줘야 한다.(어노테이션)
 */

/*
 권한: 반영이 느릴수 있어서
*/

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //3. 프로토콜 연결
        //locationManager.delegate = self
        //setRegionAndAnnotation()
        
        let center = CLLocationCoordinate2D(latitude: 37.544133, longitude: 127.075364)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100) // 디폴트 위치정보를 넣어준다. 위도, 경도, 사이즈
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "나의 동네"
        mapView.addAnnotation(annotation)
        //checkUserDeviceServiceAuthorization() 제거 가능한 이유 명확하게 알기

    }
}
    //지도 중심 설정: center는 지도 중심 위치이며 애플맵에서 얻은 좌표를 넣어준다.
    //화면 표시 범위 설정: 지도 중심 기반으로 보여질 범위를 설정한다.
    //화면 표시: 정해진 위치정보를 화면에 표시한다.
//    func setRegionAndAnnotation() {
//        let center = CLLocationCoordinate2D(latitude: 37.544133, longitude: 127.075364)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100) // 디폴트 위치정보를 넣어준다. 위도, 경도, 사이즈
//        mapView.setRegion(region, animated: true)
//
//
//        //지도에 핀추가
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = center
//        annotation.title = "이곳이 나의 캠퍼스다"
//        mapView.addAnnotation(annotation)
//    }
//
//}
/*
extension MapViewController { // 위치와 관련된 User Defined 메서드)
    func checkUserDeviceServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    //8. 사용자의 위치 권한 상태 확인 : 사용자위치 허용, 거부, 아직선택안함 등 확인(단, 사전에 iOS위치 서비스활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //앱을 사용하는 동안에 대한 위치 권한 요청(plist에 requestWhenInUseAuthorization등록해줘야 됨. 안그러면 앱꺼짐)
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면 startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
        default: print("DEFAULT")
        }
    }
    
    //한번도 설정앱에 들어가지 않은 경우, 막 다운 받은 앱인 경우에 따라 이동경로가 달라짐(설정, 설정세부화면)
    if let appSetting = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(appSetting)
    }
    
}
//4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    //4-1. 사용자위치 가져오기 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        <#code#>
        
        //Ex. 위도, 경도 기반으로 날시 정보 조회 또는 지도 다시 세팅
        //if let coordinate = locations.last?.coordinate {
        //    setRegionAndAnnotation(center: coordinate)
        //}
        
        //위치 업데이트 중지
        locationManager.stopUpdatingLocation()
    }
    //4-2. 사용자위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    //9. 사용자의 권한 상태가 바뀔때를 알려줌: 거부했다가 설정에서 변경했거나 혹은 NOTDetermined에서 허용을 했거나 등
    //만약 권한 허용해서 위치 가지고 오는 중에 설정에서 권한거부하고 돌아온다면?
    //iOS14이상: 사용자 권한 상태가 변경 될 때, 위치관리자 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceServiceAuthorization()
    }
    
    //iOS14미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        <#code#>
    }
}

extension MapViewController: MKMapViewDelegate {
    //지도에 커스텀 핀추가
    
}
*/

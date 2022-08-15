//
//  MapViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/11.
//

import UIKit
import MapKit //CLLocationManager1.
import CoreLocation


/*CLLocationManager: 위치정보
 1. import MapKit, CoreLocation
 2. 위치정보 인스턴스 선언(CLLocationManager: 위치 관련 이벤트 대부분 담당)
 3. 프로토콜 연결
 4. 프로토콜 선언
 5. extension MapViewController : 위치와 관련된 User Defined 메서드 설정
 6. 사용자의 위치 권한 상태 확인 : 사용자위치 허용, 거부, 아직선택안함 등 확인(단, 사전에 iOS위치 서비스활성화 꼭 확인)
 7. 사용자의 권한 상태가 바뀔때를 알려줌: 거부->설정, NOTDetermined->허용, 허용->거부(허용해서 위치 가지고 오는 중에 위치서비스 비활성화)
 */

/*참고
 1. 커스텀핀 만들려면 extension 추가가 필요하다.(MKMapViewDelegate)
 2. 지도정보표시
 -. 지도 중심 설정: center는 지도 중심 위치이며 애플맵에서 얻은 좌표를 넣어준다. 핀을 추가해줘야 한다.(어노테이션)
 -. 화면 표시 범위 설정: 지도 중심 기반으로 보여질 범위를 설정한다. 디폴트 위치와 범위를 지정해줘야 한다.
 -. 화면 표시: 정해진 위치정보를 화면에 표시한다. 지도와 위치권한은 상관없다. 불러온 지도에 현재위치를 표시하려면 위치 권한을 등록해줘야 한다.
 3. 지도가 움직이는 도중에는 안보이고 위치이동된곳에서만 보이려면 MKMapViewDelegate에서 regionDidChangeAnimated를 사용해주어야 한다.(기본기능 아님)
 */

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //CLLocationManager2. 위치정보 인스턴스 선언
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CLLocationManager3. 프로토콜 연결
        locationManager.delegate = self
        //setRegionAndAnnotation()
        
        let center = CLLocationCoordinate2D(latitude: 37.544133, longitude: 127.075364)
    }
    
    //viewDidLoad에서는 화면이 뜨기전이라 얼럿이 안보이므로 viewDidAppear에서 얼럿 선언해야 한다.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
    
    //위치가 변경되었을때 지도형태를 변경해주려면?
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100) // 디폴트 위치정보를 넣어준다. 위도, 경도, 사이즈
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "나의 동네"
        mapView.addAnnotation(annotation)
        //checkUserDeviceLocationServiceAuthorization() //제거 가능한 이유 명확하게 알기(viewDidLoad, locationManagerDidChangeAuthorization에서 두번 뜨기 때문에)
    }
}

//CLLocationManager5. 위치와 관련된 User Defined 메서드 설정 : iOS버젼에 따른 분기 처리 및 위치 서비스 활성화 여부 확인(활성화 -> 권한요청, 비활성화 -> 얼럿)
extension MapViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
 
        //iOS14전후에 따른 분기처리
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 확인
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로 위치 권한 요청 시도
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    //CLLocationManager6. 사용자의 위치 권한 상태 확인 : 사용자위치 허용, 거부, 아직선택안함 등 확인(단, 사전에 iOS위치 서비스활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest //위치정보 정확도 설정
            locationManager.requestWhenInUseAuthorization() //앱을 사용하는 동안에 대한 위치 권한 요청(plist에 requestWhenInUseAuthorization등록해줘야 됨. 안그러면 앱꺼짐)
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()//사용자가 위치를 허용해둔 상태라면 startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          //한번도 설정앱에 들어가지 않은 경우, 막 다운 받은 앱인 경우에 따라 설정인지 설정세부화면인지 이동화면이 달라짐
          //설정화면으로 이동하려면 액션에 설정화면연동을 해줘야 한다.(설정페이지를 openSettingsURLString로 제공해주면 해당 페이지로 이동)
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

//CLLocationManager4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    //CLLocationManager4-1. 사용자위치 가져오기 성공시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //Ex. 위도, 경도 기반으로 날씨 정보 조회 또는 지도 다시 세팅
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        
        //실시간으로 변경될 필요 없는 경우 startUpdatingLocation 중지해주어야 함. 위치이동이 많아지면 자동으로 kCLLocationAccuracyBest 실행하여 위치정보 조정함.
        locationManager.stopUpdatingLocation()
    }
    //CLLocationManager4-2. 사용자위치 가져오기 실패시
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    //CLLocationManager7. 사용자의 권한 상태가 바뀔때를 알려줌: 거부->설정, NOTDetermined->허용, 허용->거부(허용해서 위치 가지고 오는 중에 위치서비스 비활성화)
    //iOS14이상: 위치관리자 생성할 때, 사용자 권한 상태가 변경 될 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    //iOS14미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}

extension MapViewController: MKMapViewDelegate {
    
    /*지도에 커스텀 핀추가
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        <#code#>
    }
    */
    
    //지도 이동 완료시 위치정보 불러오기
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}


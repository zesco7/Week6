//
//  MainViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON


/*
 awakeFromNib: 셀UI초기화
 cellForItemAt:
 -. 재사용 될 때마다 사용자에게 보일때 마다 실행됨
 -. 화면과 데이터는 별개이므로 모든 Indexpath.index에 대한 조건이 없다면 재사용시 오류 발생할 수 있음
 prepareForReuse
 -. 셀이 재사용 될때 초기화하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉, 모든 Indexpath.index에 대한 조건 작성하지 않아도 됨
 CollectionView in TableView
 -. 하나의 컬렉션뷰나 테이블 뷰라면 스크롤 속도 때문에 문제되지 않음.
 -. 복합적인 구조라면 테이블셀, 컬렉션셀도 재사용 되어야함.
 
 */

/*code flow
 1. 네트워크 통신으로 데이터 받기
 2. 배열을 통한 데이터 인덱싱 후 배열에 담기
 3. 뷰에 표현
 **화면이랑 데이터는 따로 놀기 때문에 reloadData해줘야함.
 */
 
class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .blue, .yellow, .orange]
    
    let numberList: [[Int]] = [
        [Int](100...130),
        [Int](55...75),
        [Int](81...90),
        [Int](91...100)
        ]
     
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayOut()
        bannerCollectionView.isPagingEnabled = true // 디바이스 너비만큼 움직임. 이동폭 맞추려면 이미지를 디바이스 폭이랑 맞춰야함.
        
        //TMDBAPIManager.shared.requestImage에 담긴 데이터를 받아서 episodeList배열에 넣기
        TMDBAPIManager.shared.requestImage { value in
            dump(value)
            self.episodeList = value
            self.mainTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 10
        //return numberList.count
        return episodeList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //내부 매개변수 tableView를 통해
    //테이블뷰 객체가 하나일 경우 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .orange
        cell.titleLabel.text = "\(TMDBAPIManager.shared.tvList[indexPath.section].0)  다시보기"
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // 태그 통해 각 셀 구분  짓기
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        //cell.contentCollectionView.reloadData() /index out of range 오류 안나게 해줌
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 190
        //return indexPath.section == 3 ? 350 : 190
        return 240
    }
    
    
}
//하나의 프로토콜에서 여러 컬렉션 뷰의 delegate, datasource 구현해야함.(bannerCollectionView, UICollectionView 둘 다에서 위임해야됨)
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return collectionView == bannerCollectionView ? color.count : 10
        //return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    //bannerCollectionview 또는 테이블뷰 안에 들어 있는 컬렉션뷰 둘 다 사용 가능하다.(어떤걸 재활용할지 정하는 것이기 때문)
    //내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용되면 특정 collectionView 셀을 재사용해서 엉킬 수 있음.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("MainViewController", #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            //cell.cardView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .brown : .black
            cell.cardView.posterImageView.backgroundColor = .blue
            cell.cardView.contentLabel.textColor = .white
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            cell.cardView.contentLabel.text = ""
            
            //컬렉션뷰 레이블표시에 조건문 적용해보기
            
            //cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            //            if indexPath.item < 2 {
            //            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            //
            //            }
        }
        //cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        
        return cell
    }
    
    func collectionViewLayOut() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
        
    }
    
}



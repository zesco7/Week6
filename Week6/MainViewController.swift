//
//  MainViewController.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .blue, .yellow, .orange]
    
    let numberLIst: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](81...90),
        [Int](91...100)
        ]
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayOut()
        bannerCollectionView.isPagingEnabled = true // 디바이스 너비만큼 움직임. 이동폭 맞추려면 이미지를 디바이스 폭이랑 맞춰야함.
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 10
        return numberLIst.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .orange
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // 태그 통해 각 셀 구분  짓기
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 190
        return indexPath.section == 3 ? 350 : 190
    }
    
    
}
//하나의 프로토콜에서 여러 컬렉션 뷰의 delegate, datasource 구현해야함.(bannerCollectionView, UICollectionView 둘 다에서 위임해야됨)
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : 10
//        return collectionView == bannerCollectionView ? color.count : numberLIst[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            //cell.cardView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .brown : .black
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
            cell.cardView.contentLabel.text = "\(numberLIst[collectionView.tag][indexPath.item])"
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



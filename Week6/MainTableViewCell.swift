//
//  MainTableViewCell.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        //collectionViewLayOut()가 아니라 왜 contentCollectionView.collectionViewLayout = collectionViewLayOut()인지?
        
    }

    func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기콘텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.collectionViewLayout = collectionViewLayOut()
    }
    
    func collectionViewLayOut() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 130)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return layout
    }
}

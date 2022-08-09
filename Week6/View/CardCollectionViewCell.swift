//
//  CardCollectionViewCell.swift
//  Week6
//
//  Created by Mac Pro 15 on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setupUI()
    }
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }
}

/*
 변경되지 않는 UI: awakeFromNib
 awakeFromNib()에 setupUI()호출하면 코드 재사용하는동안에 변경되지 않는 ui 적용
 */

//
//  BaseCollectionViewCell.swift
//  Example
//
//  Created by JiongXing on 2018/10/14.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

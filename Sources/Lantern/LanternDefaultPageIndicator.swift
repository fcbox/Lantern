//
//  LanternDefaultPageIndicator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

open class LanternDefaultPageIndicator: UIPageControl, LanternPlug {
    
    /// 页码与底部的距离
    open lazy var bottomPadding: CGFloat = {
        if #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow,
            window.safeAreaInsets.bottom > 0 {
            return 20
        }
        return 15
    }()
    
    open func setup(with lantern: Lantern) {
        isEnabled = false
        
        if superview != lantern.view {
            removeFromSuperview()
            
            lantern.view.addSubview(self)
            translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 9.0, *) {
                centerXAnchor.constraint(equalTo: lantern.view.centerXAnchor).isActive = true
                bottomAnchor.constraint(equalTo: lantern.view.bottomAnchor, constant: -bottomPadding).isActive = true
            }
        }
    }
    
    open func reloadData(numberOfItems: Int, pageIndex: Int) {
        numberOfPages = numberOfItems
        currentPage = min(pageIndex, numberOfPages - 1)
        sizeToFit()
        isHidden = numberOfPages <= 1
    }
    
    open func didChanged(pageIndex: Int) {
        currentPage = pageIndex
    }
}

//
//  LanternNumberPageIndicator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

open class LanternNumberPageIndicator: UILabel, LanternPlug {
    
    ///  页码与顶部的距离
    open lazy var topPadding: CGFloat = {
        if #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.top
        }
        return 20
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .center
        textColor = UIColor.white
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        layer.masksToBounds = true
    }
    
    public func setup(with lantern: Lantern) {
        if superview != lantern.view {
            lantern.view.addSubview(self)
            
            translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 9.0, *) {
                centerXAnchor.constraint(equalTo: lantern.view.centerXAnchor).isActive = true
                topAnchor.constraint(equalTo: lantern.view.topAnchor, constant: topPadding).isActive = true
            }
        }
    }
    
    private var total: Int = 0
    
    public func reloadData(numberOfItems: Int, pageIndex: Int) {
        total = numberOfItems
        text = "\(pageIndex + 1) / \(total)"
        sizeToFit()
        layer.cornerRadius = frame.height / 2
        
        if numberOfItems <= 1 {
            isHidden = true
        }
    }
    
    public func didChanged(pageIndex: Int) {
        text = "\(pageIndex + 1) / \(total)"
    }
    
}

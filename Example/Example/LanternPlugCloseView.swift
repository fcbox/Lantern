//
//  LanternPlugCloseView.swift
//  Example
//
//  Created by sky on 2021/12/16.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd. All rights reserved.
//

import UIKit
import Lantern

open class LanternPlugCloseView: UIView, LanternPlug {
    
    /// 弱引用PhotoBrowser
    open weak var lantern: Lantern?
    
    var closeBtn: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    public var ignoreToggle: Bool = true
    
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
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.topAnchor.constraint(equalTo: topAnchor).isActive = true
        closeBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        closeBtn.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    public func setup(with lantern: Lantern) {
        self.lantern = lantern
        
        if superview != lantern.view {
            lantern.view.addSubview(self)
            
            translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 9.0, *) {
                trailingAnchor.constraint(equalTo: lantern.view.trailingAnchor, constant: -15).isActive = true
                topAnchor.constraint(equalTo: lantern.view.topAnchor, constant: 35).isActive = true
            }
        }
    }
    
    
    @objc func closeBtnClicked() {
        lantern?.dismiss()
    }
}

//
//  LanternPlugCloseView.swift
//  Example
//
//  Created by sky on 2021/12/16.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd. All rights reserved.
//

import UIKit
import Lantern

open class LanternPlugCloseItem: LanternPlug {
    
    /// 弱引用PhotoBrowser
    weak var lantern: Lantern?
    
    var closeBtn: UIButton = {
        var button: UIButton
        if #available(iOS 13.0, *) {
            button = UIButton(type: .close)
        } else {
            button = UIButton(type: .custom)
            button.setTitle("X", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.darkGray
            // Fallback on earlier versions
        }
        return button
    }()
    
    public var ignoreToggle: Bool = true
    
    ///  页码与顶部的距离
    lazy var topPadding: CGFloat = {
        if #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.top
        }
        return 20
    }()
    
    public func setup(with lantern: Lantern) {
        self.lantern = lantern
        
        if closeBtn.superview != lantern.view {
            closeBtn.removeFromSuperview()
            closeBtn.removeTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
            
            lantern.view.addSubview(closeBtn)
            closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
            closeBtn.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 9.0, *) {
                closeBtn.translatesAutoresizingMaskIntoConstraints = false
                closeBtn.topAnchor.constraint(equalTo: lantern.view.topAnchor, constant: 35).isActive = true
                closeBtn.trailingAnchor.constraint(equalTo: lantern.view.trailingAnchor, constant: -15).isActive = true
                closeBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
                closeBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
            }
        }
    }
    
    
    @objc func closeBtnClicked() {
        lantern?.dismiss()
    }
    
    public var isPlugHidden: Bool {
        get { closeBtn.isHidden }
    }
    
    public func hidePlug(hidden: Bool, animated: Bool = true) {
        if animated {
            closeBtn.isHidden = hidden
        } else {
            UIView.animate(withDuration: 0.15) {
                let targetAlpha: CGFloat = hidden ? 0.0 : 1.0

                self.closeBtn.alpha = targetAlpha
            } completion: { success in
                if success {
                    self.closeBtn.isHidden = hidden
                }
            }
        }
    }
    
    public func removeFromLantern() {
        closeBtn.removeFromSuperview()
    }
}

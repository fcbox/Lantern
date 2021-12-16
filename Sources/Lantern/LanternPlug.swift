//
//  LanternPlug.swift
//  Lantern
//
//  Created by sky on 2021/12/16.
//

import Foundation

public protocol LanternPlug {
    
    func setup(with lantern: Lantern)
    
    // optional
    
    var isPlugHidden: Bool { get }
    
    var ignoreToggle: Bool { get }
    
    func reloadData(numberOfItems: Int, pageIndex: Int)
    
    func didChanged(pageIndex: Int)
    
    func hidePlug(hidden: Bool, animated: Bool)
}

extension LanternPlug {
    public var isPlugHidden: Bool {
        get { false }
    }
    
    public var ignoreToggle: Bool {
        get { false }
    }
    
    public func reloadData(numberOfItems: Int, pageIndex: Int) {
        debugPrint("defalut plug reloadData")
    }
    
    public func didChanged(pageIndex: Int) {
        debugPrint("defalut plug didChanged")
    }
    
    public func hidePlug(hidden: Bool, animated: Bool) {
        debugPrint("defalut plug hidePlug")
    }
}

extension LanternPlug where Self: UIView {
    public var isPlugHidden: Bool {
        get { isHidden }
    }
    
    public func hidePlug(hidden: Bool, animated: Bool = true) {
        if animated {
            isHidden = hidden
        } else {
            UIView.animate(withDuration: 0.15) {
                let targetAlpha: CGFloat = hidden ? 0.0 : 1.0

                self.alpha = targetAlpha
            } completion: { success in
                if success {
                    self.isHidden = hidden
                }
            }
        }
    }
}

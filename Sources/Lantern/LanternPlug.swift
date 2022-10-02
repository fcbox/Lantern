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
        
    func reloadData(numberOfItems: Int, pageIndex: Int)
    
    func didChanged(pageIndex: Int)
    
    func hidePlug(hidden: Bool, animated: Bool)
    
    func removeFromLantern()
}

extension LanternPlug {

    public func reloadData(numberOfItems: Int, pageIndex: Int) {
        debugPrint("defalut plug reloadData")
    }
    
    public func didChanged(pageIndex: Int) {
        debugPrint("defalut plug didChanged")
    }
    
    public func hidePlug(hidden: Bool, animated: Bool) {
        debugPrint("defalut plug hidePlug")
    }
    
    public func removeFromLantern() {
        debugPrint("defalut plug removeFromLantern")
    }
}

extension LanternPlug where Self: UIView {
    public func removeFromLantern() {
        removeFromSuperview()
    }
}

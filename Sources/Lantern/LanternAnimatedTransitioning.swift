//
//  LanternAnimatedTransitioning.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

public protocol LanternAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var isForShow: Bool { get set }
    var lantern: Lantern? { get set }
    var isNavigationAnimation: Bool { get set }
}

private var isForShowKey = "isForShowKey"
private var lanternKey = "lanternKey"

/// 对象不支持使用assign来存储，会崩溃，用object的weak变量包装一下，刚修改就遇到了这个崩溃，所以修改一下
class LanternWeakObject: NSObject {
    weak var object: AnyObject?
    init(_ object: AnyObject) {
        self.object = object
    }
}

extension LanternAnimatedTransitioning {

    public var isForShow: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &isForShowKey) as? Bool {
                return value
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &isForShowKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public weak var lantern: Lantern? {
        get {
            (objc_getAssociatedObject(self, &lanternKey) as? LanternWeakObject)?.object as? Lantern
        }
        set {
            if let newValue {
                objc_setAssociatedObject(self, &lanternKey, LanternWeakObject(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &lanternKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    public var isNavigationAnimation: Bool {
        get { false }
        set { }
    }

    public func fastSnapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }

    public func snapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}

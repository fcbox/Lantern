//
//  LanternNoneAnimator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2019 FengChao. All rights reserved.
//

import UIKit

open class LanternNoneAnimator: NSObject, LanternAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(transitionContext.transitionWasCancelled)
    }
    
    
    open func show(browser: Lantern, completion: @escaping () -> Void) {
        completion()
    }
    
    open func dismiss(browser: Lantern, completion: @escaping () -> Void) {
        completion()
    }
}

//
//  LanternSmoothZoomAnimator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

/// 更丝滑的Zoom动画
open class LanternSmoothZoomAnimator: NSObject, LanternAnimatedTransitioning {
    
    open var showDuration: TimeInterval = 0.25
    
    open var dismissDuration: TimeInterval = 0.25
    
    open var isNavigationAnimation = false
    
    public typealias TransitionViewAndFrame = (transitionView: UIView, thumbnailFrame: CGRect)
    public typealias TransitionViewAndFrameProvider = (_ index: Int, _ destinationView: UIView) -> TransitionViewAndFrame?
    
    /// 获取转场缩放的视图与前置Frame
    open var transitionViewAndFrameProvider: TransitionViewAndFrameProvider = { _, _ in return nil }
    
    /// 替补的动画方案
    open lazy var substituteAnimator: LanternAnimatedTransitioning = LanternFadeAnimator()
    
    public init(transitionViewAndFrame: @escaping TransitionViewAndFrameProvider) {
        transitionViewAndFrameProvider = transitionViewAndFrame
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isForShow ? showDuration : dismissDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isForShow {
            playShowAnimation(context: transitionContext)
        } else {
            playDismissAnimation(context: transitionContext)
        }
    }
    
    private func playShowAnimation(context: UIViewControllerContextTransitioning) {
        guard let browser = lantern else {
            context.completeTransition(!context.transitionWasCancelled)
            return
        }
        if isNavigationAnimation,
            let fromView = context.view(forKey: .from),
            let fromViewSnapshot = snapshot(with: fromView),
            let toView = context.view(forKey: .to)  {
            toView.insertSubview(fromViewSnapshot, at: 0)
        }
        context.containerView.addSubview(browser.view)
        
        guard let (transitionView, thumbnailFrame, destinationFrame) = transitionViewAndFrames(with: browser) else {
            // 转为执行替补动画
            substituteAnimator.isForShow = isForShow
            substituteAnimator.lantern = lantern
            substituteAnimator.isNavigationAnimation = isNavigationAnimation
            substituteAnimator.animateTransition(using: context)
            return
        }
        browser.maskView.alpha = 0
        browser.browserView.isHidden = true
        transitionView.frame = thumbnailFrame
        context.containerView.addSubview(transitionView)
        UIView.animate(withDuration: showDuration, animations: {
            browser.maskView.alpha = 1.0
            transitionView.frame = destinationFrame
        }) { _ in
            browser.browserView.isHidden = false
            browser.view.insertSubview(browser.maskView, belowSubview: browser.browserView)
            transitionView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func playDismissAnimation(context: UIViewControllerContextTransitioning) {
        guard let browser = lantern else {
            return
        }
        guard let (transitionView, thumbnailFrame, destinationFrame) = transitionViewAndFrames(with: browser) else {
            // 转为执行替补动画
            substituteAnimator.isForShow = isForShow
            substituteAnimator.lantern = lantern
            substituteAnimator.isNavigationAnimation = isNavigationAnimation
            substituteAnimator.animateTransition(using: context)
            return
        }
        browser.browserView.isHidden = true
        transitionView.frame = destinationFrame
        context.containerView.addSubview(transitionView)
        UIView.animate(withDuration: showDuration, animations: {
            browser.maskView.alpha = 0
            transitionView.frame = thumbnailFrame
        }) { _ in
            if let toView = context.view(forKey: .to) {
                context.containerView.addSubview(toView)
            }
            transitionView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func transitionViewAndFrames(with browser: Lantern) -> (UIView, CGRect, CGRect)? {
        let browserView = browser.browserView
        let destinationView = browser.view!
        guard let transitionContext = transitionViewAndFrameProvider(browser.pageIndex, destinationView) else {
            return nil
        }
        guard let cell = browserView.visibleCells[browserView.pageIndex] as? LanternZoomSupportedCell else {
            return nil
        }
        let showContentView = cell.showContentView
        let destinationFrame = showContentView.convert(showContentView.bounds, to: destinationView)
        return (transitionContext.transitionView, transitionContext.thumbnailFrame, destinationFrame)
    }
}

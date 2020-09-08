//
//  LanternVideoView.swift
//  Lantern
//
//  Created by 肖志斌 on 2020/9/4.
//

import UIKit
import AVFoundation

class LanternVideoView: UIView {
    /// 弱引用lantern
    open weak var lantern: Lantern?
    /// 容器
    open lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.isScrollEnabled = true
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = .never
        }
        return sv
    }()
    /// 背景蒙版
    open lazy var wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    /// 播放器
    open lazy var player = AVPlayer()
    open lazy var playerLayer = AVPlayerLayer(player: player)
    
    deinit {
        LanternLog.high("deinit - \(self.classForCoder)")
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(wrapper)
        self.addSubview(scrollView)
       
        layer.addSublayer(playerLayer)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    @objc private func handlePanGesture() {
        lantern?.dismiss()
    }
}

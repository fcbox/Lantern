//
//  VideoCell.swift
//  Example
//
//  Created by JiongXing on 2019/12/13.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Lantern

class VideoCell: UIView, LanternCell {
    
    weak var lantern: Lantern?
    
    lazy var player = AVPlayer()
    lazy var playerLayer = AVPlayerLayer(player: player)
    
    static func generate(with lantern: Lantern) -> Self {
        let instance = Self.init(frame: .zero)
        instance.lantern = lantern
        return instance
    }
    
    required override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        addGestureRecognizer(tap)
        
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    @objc private func click() {
        lantern?.dismiss()
    }
}

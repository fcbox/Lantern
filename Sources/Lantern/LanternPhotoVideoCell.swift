//
//  LanternPhotoVideoCell.swift
//  Lantern
//
//  Created by 小豌先生 on 2023/7/20.
//

import UIKit

open class LanternPhotoVideoCell: LanternImageCell {
    public var player: LanternVideoPlayer = {
        let view = LanternVideoPlayer()
        return view
    }()
   
    open override func setup() {
        imageView.isUserInteractionEnabled = true
        contentView = player
        super.setup()
    }
    
    open func refreshPlayer() {
        self.panGestureEndAction = {[weak self] (_, isEnd) in
            if isEnd {
                self?.player.stop()
            } else {
                self?.player.play()
            }
        }
        self.panGestureChangeAction = { [weak self] (_, _) in
            self?.player.pause()
        }
    }
    
    open func showPlayer(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.player.url = url
            self.isVideo = true
            self.player.play()
        }
    }
}



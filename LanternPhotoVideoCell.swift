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
        self.playAction = { _ in
            self.player.play()
        }
        self.pauseAction = { _ in
            self.player.pause()
        }
        self.stopAction = { _ in
            self.player.stop()
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



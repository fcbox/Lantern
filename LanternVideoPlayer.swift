//
//  LanternVideoPlayer.swift
//  Lantern
//
//  Created by 小豌先生 on 2023/7/20.
//

import UIKit
import AVFoundation

open class LanternVideoPlayer: UIView {
    
    private var player: AVPlayer?

    private var playerLayer: AVPlayerLayer?

    private var playerItem: AVPlayerItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var url: URL? {
        didSet {
            guard let url = url else { return }
            
            self.stop()
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playback)
                try session.setActive(true)
            } catch {
                print("set session error:\(error)")
            }
            
            playerItem = AVPlayerItem(asset: AVAsset(url: url))
            player = AVPlayer(playerItem: playerItem)
            playerLayer = layer as? AVPlayerLayer
            playerLayer?.videoGravity = .resizeAspect
            playerLayer?.player = player
        }
    }
}

public extension LanternVideoPlayer {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.classForCoder()
    }
}

public extension LanternVideoPlayer {
    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        playerItem = nil
        player = nil
        playerLayer = nil
    }
}


//
//  LanternPlayer.swift
//  Lantern
//
//  Created by 肖志斌 on 2020/9/6.
//

import UIKit
import Foundation
import AVFoundation
import CoreGraphics

// MARK: - types

/// 视频填充模式选项。
///
/// -调整大小:拉伸填充。
/// - resizeAspectFill:保留高宽比，填充边界。
/// - resizeAspectFit:保持高宽比，在限定范围内填充。
public typealias PlayerFillMode = AVLayerVideoGravity

/// 播放状态
public enum PlaybackState: Int, CustomStringConvertible {
    case stopped = 0
    case playing
    case paused
    case failed

    public var description: String {
        get {
            switch self {
            case .stopped:
                return "Stopped"
            case .playing:
                return "Playing"
            case .failed:
                return "Failed"
            case .paused:
                return "Paused"
            }
        }
    }
}

/// 缓冲状态
public enum BufferingState: Int, CustomStringConvertible {
    case unknown = 0
    case ready
    case delayed

    public var description: String {
        get {
            switch self {
            case .unknown:
                return "Unknown"
            case .ready:
                return "Ready"
            case .delayed:
                return "Delayed"
            }
        }
    }
}
// MARK: - error types

/// 错误提示码.
public let PlayerErrorDomain = "PlayerErrorDomain"

/// Error types.
public enum PlayerError: Error, CustomStringConvertible {
    case failed

    public var description: String {
        get {
            switch self {
            case .failed:
                return "failed"
            }
        }
    }
}

// MARK: - PlayerDelegate

/// Player delegate protocol
public protocol PlayerDelegate: AnyObject {
    func playerReady(_ player: LanternPlayer)
    func playerPlaybackStateDidChange(_ player: LanternPlayer)
    func playerBufferingStateDidChange(_ player: LanternPlayer)

    //这是视频被缓冲的秒数。
    //如果实现一个UIProgressView。设置进度的最大持续时间。
    func playerBufferTimeDidChange(_ bufferTime: Double)

    func player(_ player: LanternPlayer, didFailWithError error: Error?)
}


/// Player playback protocol
public protocol PlayerPlaybackDelegate: AnyObject {
    func playerCurrentTimeDidChange(_ player: LanternPlayer)
    func playerPlaybackWillStartFromBeginning(_ player: LanternPlayer)
    func playerPlaybackDidEnd(_ player: LanternPlayer)
    func playerPlaybackWillLoop(_ player: LanternPlayer)
}

// MARK: - LanternPlayer

open class LanternPlayer: UIViewController {

    /// Player delegate.
    open weak var playerDelegate: PlayerDelegate?

    /// Playback delegate.
    open weak var playbackDelegate: PlayerPlaybackDelegate?

    /// 要播放的文件资产的本地或远程URL
   
    open var url: URL? {
        didSet {
            if let url = self.url {
                setup(url: url)
            }
        }
    }

    /// AVAsset
    /// 注意:重置URL(不能同时设置URL)
    open var asset: AVAsset? {
        get { return _asset }
        set { _ = newValue.map { setupAsset($0) } }
    }

    /// 指定视频如何在播放器层的边界内显示。
    /// 默认值为AVLayerVideoGravityResizeAspect
    
    open var fillMode: PlayerFillMode {
        get {
            return self._playerView.playerFillMode
        }
        set {
            self._playerView.playerFillMode = newValue
        }
    }

    /// 确定设置url时视频是否应该自动播放
    ///
    /// - Parameter bool: 默认为true
    open var autoplay: Bool = true

    /// 静音音频播放 默认为true
    open var muted: Bool {
        get {
            return self._avplayer.isMuted
        }
        set {
            self._avplayer.isMuted = newValue
        }
    }

    /// 音量，从0.0到1.0的线性范围
    open var volume: Float {
        get {
            return self._avplayer.volume
        }
        set {
            self._avplayer.volume = newValue
        }
    }

    /// 退出活动时自动暂停回放.
    open var playbackPausesWhenResigningActive: Bool = true

    /// 后台运行时自动暂停回放
    open var playbackPausesWhenBackgrounded: Bool = true

    /// 激活后恢复回放
    open var playbackResumesWhenBecameActive: Bool = true

    /// 进入前台恢复回放
    open var playbackResumesWhenEnteringForeground: Bool = true

    /// 自动连续循环播放
    open var playbackLoops: Bool {
        get {
            return self._avplayer.actionAtItemEnd == .none
        }
        set {
            if newValue {
                self._avplayer.actionAtItemEnd = .none
            } else {
                self._avplayer.actionAtItemEnd = .pause
            }
        }
    }

    /// 回放在最后一帧停止 默认为true
    open var playbackFreezesAtEnd: Bool = false

    /// 播放状态
    open var playbackState: PlaybackState = .stopped {
        didSet {
            if playbackState != oldValue || !playbackEdgeTriggered {
                self.executeClosureOnMainQueueIfNecessary {
                    self.playerDelegate?.playerPlaybackStateDidChange(self)
                }
            }
        }
    }

    /// 缓冲状态
    open var bufferingState: BufferingState = .unknown {
        didSet {
            if bufferingState != oldValue || !playbackEdgeTriggered {
                self.executeClosureOnMainQueueIfNecessary {
                    self.playerDelegate?.playerBufferingStateDidChange(self)
                }
            }
        }
    }

    /// 缓冲大小(秒)
    open var bufferSizeInSeconds: Double = 10

    /// 当状态为true，回放不会自动触发
    open var playbackEdgeTriggered: Bool = true

    /// 播放的最大持续时间
    open var maximumDuration: TimeInterval {
        get {
            if let playerItem = self._playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }

    /// 回放的当前时间
    open var currentTime: TimeInterval {
        get {
            if let playerItem = self._playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }

    /// 播放器的自然尺度
    open var naturalSize: CGSize {
        get {
            if let playerItem = self._playerItem,
                let track = playerItem.asset.tracks(withMediaType: .video).first {

                let size = track.naturalSize.applying(track.preferredTransform)
                return CGSize(width: abs(size.width), height: abs(size.height))
            } else {
                return CGSize.zero
            }
        }
    }

    public var playerView: PlayerView {
        get {
            return self._playerView
        }
    }
    /// 视频图层
    open func playerLayer() -> AVPlayerLayer? {
        return self._playerView.playerLayer
    }

    /// 网络带宽消耗
    open var preferredPeakBitRate: Double = 0 {
        didSet {
            self._playerItem?.preferredPeakBitRate = self.preferredPeakBitRate
        }
    }

    /// 下载的视频的分辨率的首选上限
    @available(iOS 11.0, tvOS 11.0, *)
    open var preferredMaximumResolution: CGSize {
        get {
            return self._playerItem?.preferredMaximumResolution ?? CGSize.zero
        }
        set {
            self._playerItem?.preferredMaximumResolution = newValue
            self._preferredMaximumResolution = newValue
        }
    }

    // MARK: - 私有属性

    internal var _asset: AVAsset? {
        didSet {
            if let _ = self._asset {
                self.setupPlayerItem(nil)
            }
        }
    }
    internal var _avplayer: AVPlayer = AVPlayer()
    internal var _playerItem: AVPlayerItem?

    internal var _playerObservers = [NSKeyValueObservation]()
    internal var _playerItemObservers = [NSKeyValueObservation]()
    internal var _playerLayerObserver: NSKeyValueObservation?
    internal var _playerTimeObserver: Any?

    internal var _playerView: PlayerView = PlayerView(frame: .zero)
    internal var _seekTimeRequested: CMTime?
    internal var _lastBufferTime: Double = 0
    internal var _preferredMaximumResolution: CGSize = .zero

    // 确定用户或调用代码是否手动触发了自动播放
    internal var _hasAutoplayActivated: Bool = true

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self._avplayer.actionAtItemEnd = .pause
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._avplayer.actionAtItemEnd = .pause
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    deinit {
        self._avplayer.pause()
        self.setupPlayerItem(nil)

        self.removePlayerObservers()

        self.playerDelegate = nil
        self.removeApplicationObservers()

        self.playbackDelegate = nil
        self.removePlayerLayerObservers()

        self._playerView.player = nil
    }

    // MARK: - 视图

    open override func loadView() {
        super.loadView()
        self._playerView.frame = self.view.bounds
        self.view = self._playerView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        if let url = self.url {
            setup(url: url)
        } else if let asset = self.asset {
            setupAsset(asset)
        }

        self.addPlayerLayerObservers()
        self.addPlayerObservers()
        self.addApplicationObservers()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.playbackState == .playing {
            self.pause()
        }
    }

}

// MARK: - 播放器播放暂停停止等方法

extension LanternPlayer {

    /// 从头开始播放
    open func playFromBeginning() {
        self.playbackDelegate?.playerPlaybackWillStartFromBeginning(self)
        self._avplayer.seek(to: CMTime.zero)
        self.playFromCurrentTime()
    }

    /// 从当前时间开始播放
    open func playFromCurrentTime() {
        if !self.autoplay {
            //外部调用此方法，自动播放关闭。在调用播放之前激活它
            self._hasAutoplayActivated = true
        }
        self.play()
    }

    fileprivate func play() {
        if self.autoplay || self._hasAutoplayActivated {
            self.playbackState = .playing
            self._avplayer.play()
        }
    }

    /// 暂停
    open func pause() {
        if self.playbackState != .playing {
            return
        }

        self._avplayer.pause()
        self.playbackState = .paused
    }

    /// 停止
    open func stop() {
        if self.playbackState == .stopped {
            return
        }

        self._avplayer.pause()
        self.playbackState = .stopped
        self.playbackDelegate?.playerPlaybackDidEnd(self)
    }

    ///更新播放到指定时间。
    ///
    /// - Parameters:
    /// -时间:切换到移动播放的时间。
    /// - completionHandler:调用后的回调/
    open func seek(to time: CMTime, completionHandler: ((Bool) -> Swift.Void)? = nil) {
        if let playerItem = self._playerItem {
            return playerItem.seek(to: time, completionHandler: completionHandler)
        } else {
            _seekTimeRequested = time
        }
    }

    ///更新播放时间到指定的时间限制。
    ///
    /// - Parameters:
    /// -时间:切换到移动播放的时间。
    /// -公差:时间之前允许的公差。
    /// -事后公差:事后允许的公差。
    /// - completionHandler:调用块处理程序后寻求
    open func seekToTime(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: ((Bool) -> Swift.Void)? = nil) {
        if let playerItem = self._playerItem {
            return playerItem.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler)
        }
    }

    ///捕获当前播放器屏幕快照。
    ///
    /// -参数completionHandler:返回被请求视频帧的UIImage。(对缩略图!)
    open func takeSnapshot(completionHandler: ((_ image: UIImage?, _ error: Error?) -> Void)? ) {
        guard let asset = self._playerItem?.asset else {
            DispatchQueue.main.async {
                completionHandler?(nil, nil)
            }
            return
        }

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let currentTime = self._playerItem?.currentTime() ?? CMTime.zero

        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: currentTime)]) { (requestedTime, image, actualTime, result, error) in
            if let image = image {
                switch result {
                case .succeeded:
                    let uiimage = UIImage(cgImage: image)
                    DispatchQueue.main.async {
                        completionHandler?(uiimage, nil)
                    }
                    break
                case .failed:
                    fallthrough
                case .cancelled:
                    fallthrough
                @unknown default:
                    DispatchQueue.main.async {
                        completionHandler?(nil, nil)
                    }
                    break
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
            }
        }
    }

}

// MARK: - loading funcs

extension LanternPlayer {

    fileprivate func setup(url: URL) {
        guard isViewLoaded else { return }

        // 重置
        if self.playbackState == .playing {
            self.pause()
        }

        //设置了一个新url后重置自动播放
        self._hasAutoplayActivated = false
        if self.autoplay {
            self.playbackState = .playing
        } else {
            self.playbackState = .stopped
        }

        self.setupPlayerItem(nil)

        let asset = AVURLAsset(url: url, options: .none)
        self.setupAsset(asset)
    }

    fileprivate func setupAsset(_ asset: AVAsset, loadableKeys: [String] = ["tracks", "playable", "duration"]) {
        guard isViewLoaded else { return }

        if self.playbackState == .playing {
            self.pause()
        }

        self.bufferingState = .unknown

        self._asset = asset

        self._asset?.loadValuesAsynchronously(forKeys: loadableKeys, completionHandler: { () -> Void in
            if let asset = self._asset {
                for key in loadableKeys {
                    var error: NSError? = nil
                    let status = asset.statusOfValue(forKey: key, error: &error)
                    if status == .failed {
                        self.playbackState = .failed
                        self.executeClosureOnMainQueueIfNecessary {
                            self.playerDelegate?.player(self, didFailWithError: PlayerError.failed)
                        }
                        return
                    }
                }

                if !asset.isPlayable {
                    self.playbackState = .failed
                    self.executeClosureOnMainQueueIfNecessary {
                        self.playerDelegate?.player(self, didFailWithError: PlayerError.failed)
                    }
                    return
                }

                let playerItem = AVPlayerItem(asset:asset)
                self.setupPlayerItem(playerItem)
            }
        })
    }

    fileprivate func setupPlayerItem(_ playerItem: AVPlayerItem?) {

        self.removePlayerItemObservers()

        if let currentPlayerItem = self._playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: currentPlayerItem)
        }

        self._playerItem = playerItem

        self._playerItem?.preferredPeakBitRate = self.preferredPeakBitRate
        if #available(iOS 11.0, tvOS 11.0, *) {
            self._playerItem?.preferredMaximumResolution = self._preferredMaximumResolution
        }

        if let seek = self._seekTimeRequested, self._playerItem != nil {
            self._seekTimeRequested = nil
            self.seek(to: seek)
        }

        if let updatedPlayerItem = self._playerItem {
            self.addPlayerItemObservers()
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime(_:)), name: .AVPlayerItemDidPlayToEndTime, object: updatedPlayerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: updatedPlayerItem)
        }

        self._avplayer.replaceCurrentItem(with: self._playerItem)

        // 更新新的playerItem设置
        if self.playbackLoops {
            self._avplayer.actionAtItemEnd = .none
        } else {
            self._avplayer.actionAtItemEnd = .pause
        }
    }

}

// MARK: - NSNotifications通知

extension LanternPlayer {

    // MARK: - UIApplication

    internal func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    internal func removeApplicationObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - AVPlayerItem handlers

    @objc internal func playerItemDidPlayToEndTime(_ aNotification: Notification) {
        self.executeClosureOnMainQueueIfNecessary {
            if self.playbackLoops {
                self.playbackDelegate?.playerPlaybackWillLoop(self)
                self._avplayer.pause()
                self._avplayer.seek(to: CMTime.zero)
                self._avplayer.play()
            } else if self.playbackFreezesAtEnd {
                self.stop()
            } else {
                self._avplayer.seek(to: CMTime.zero, completionHandler: { _ in
                    self.stop()
                })
            }
        }
    }

    @objc internal func playerItemFailedToPlayToEndTime(_ aNotification: Notification) {
        self.playbackState = .failed
    }

    // MARK: - UIApplication handlers

    @objc internal func handleApplicationWillResignActive(_ aNotification: Notification) {
        if self.playbackState == .playing && self.playbackPausesWhenResigningActive {
            self.pause()
        }
    }

    @objc internal func handleApplicationDidBecomeActive(_ aNotification: Notification) {
        if self.playbackState == .paused && self.playbackResumesWhenBecameActive {
            self.play()
        }
    }

    @objc internal func handleApplicationDidEnterBackground(_ aNotification: Notification) {
        if self.playbackState == .playing && self.playbackPausesWhenBackgrounded {
            self.pause()
        }
    }

    @objc internal func handleApplicationWillEnterForeground(_ aNoticiation: Notification) {
        if self.playbackState != .playing && self.playbackResumesWhenEnteringForeground {
            self.play()
        }
    }

}

// MARK: - KVO

extension LanternPlayer {

    // MARK: - AVPlayerItemObservers

    internal func addPlayerItemObservers() {
        guard let playerItem = self._playerItem else {
            return
        }

        self._playerItemObservers.append(playerItem.observe(\.isPlaybackBufferEmpty, options: [.new, .old]) { [weak self] (object, change) in
            if object.isPlaybackBufferEmpty {
                self?.bufferingState = .delayed
            }

            switch object.status {
            case .readyToPlay:
                self?._playerView.player = self?._avplayer
            case .failed:
                self?.playbackState = PlaybackState.failed
            default:
                break
            }
        })

        self._playerItemObservers.append(playerItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new, .old]) { [weak self] (object, change) in
            guard let strongSelf = self else {
                return
            }
            
            if object.isPlaybackLikelyToKeepUp {
                strongSelf.bufferingState = .ready
                if strongSelf.playbackState == .playing {
                    strongSelf.playFromCurrentTime()
                }
            }

            switch object.status {
            case .failed:
                strongSelf.playbackState = PlaybackState.failed
                break
            case .unknown:
                fallthrough
            case .readyToPlay:
                fallthrough
            @unknown default:
                strongSelf._playerView.player = self?._avplayer
                break
            }
        })

//        self._playerItemObservers.append(playerItem.observe(\.status, options: [.new, .old]) { (object, change) in
//        })

        self._playerItemObservers.append(playerItem.observe(\.loadedTimeRanges, options: [.new, .old]) { [weak self] (object, change) in
            guard let strongSelf = self else {
                return
            }

            let timeRanges = object.loadedTimeRanges
            if let timeRange = timeRanges.first?.timeRangeValue {
                let bufferedTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration))
                if strongSelf._lastBufferTime != bufferedTime {
                    strongSelf._lastBufferTime = bufferedTime
                    strongSelf.executeClosureOnMainQueueIfNecessary {
                        strongSelf.playerDelegate?.playerBufferTimeDidChange(bufferedTime)
                    }
                }
            }

            let currentTime = CMTimeGetSeconds(object.currentTime())
            let passedTime = strongSelf._lastBufferTime <= 0 ? currentTime : (strongSelf._lastBufferTime - currentTime)

            if (passedTime >= strongSelf.bufferSizeInSeconds ||
                strongSelf._lastBufferTime == strongSelf.maximumDuration ||
                timeRanges.first == nil) &&
                strongSelf.playbackState == .playing {
                strongSelf.play()
            }
        })
    }

    internal func removePlayerItemObservers() {
        for observer in self._playerItemObservers {
            observer.invalidate()
        }
        self._playerItemObservers.removeAll()
    }

    // MARK: - AVPlayerLayerObservers

    internal func addPlayerLayerObservers() {
        self._playerLayerObserver = self._playerView.playerLayer.observe(\.isReadyForDisplay, options: [.new, .old]) { [weak self] (object, change) in
            self?.executeClosureOnMainQueueIfNecessary {
                if let strongSelf = self {
                    strongSelf.playerDelegate?.playerReady(strongSelf)
                }
            }
        }
    }

    internal func removePlayerLayerObservers() {
        self._playerLayerObserver?.invalidate()
        self._playerLayerObserver = nil
    }

    // MARK: - AVPlayerObservers

    internal func addPlayerObservers() {
        self._playerTimeObserver = self._avplayer.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: DispatchQueue.main, using: { [weak self] timeInterval in
            guard let strongSelf = self else {
                return
            }
            strongSelf.playbackDelegate?.playerCurrentTimeDidChange(strongSelf)
        })

        if #available(iOS 10.0, tvOS 10.0, *) {
            self._playerObservers.append(self._avplayer.observe(\.timeControlStatus, options: [.new, .old]) { [weak self] (object, change) in
                switch object.timeControlStatus {
                case .paused:
                    self?.playbackState = .paused
                case .playing:
                    self?.playbackState = .playing
                case .waitingToPlayAtSpecifiedRate:
                    fallthrough
                @unknown default:
                    break
                }
            })
        }

    }

    internal func removePlayerObservers() {
        if let observer = self._playerTimeObserver {
            self._avplayer.removeTimeObserver(observer)
        }
        for observer in self._playerObservers {
            observer.invalidate()
        }
        self._playerObservers.removeAll()
    }

}

// MARK: - queues队列

extension LanternPlayer {

    internal func executeClosureOnMainQueueIfNecessary(withClosure closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }

}

// MARK: - PlayerView

public class PlayerView: UIView {

    // MARK: - overrides

    public override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }

    // MARK: - internal properties内部属性

    internal var playerLayer: AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }

    internal var player: AVPlayer? {
        get {
            return self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
            self.playerLayer.isHidden = (self.playerLayer.player == nil)
        }
    }

    // MARK: - public properties公共属性

    public var playerBackgroundColor: UIColor? {
        get {
            if let cgColor = self.playerLayer.backgroundColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            self.playerLayer.backgroundColor = newValue?.cgColor
        }
    }

    public var playerFillMode: PlayerFillMode {
        get {
            return self.playerLayer.videoGravity
        }
        set {
            self.playerLayer.videoGravity = newValue
        }
    }

    public var isReadyForDisplay: Bool {
        get {
            return self.playerLayer.isReadyForDisplay
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.playerLayer.isHidden = true
        self.playerFillMode = .resizeAspect
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.playerLayer.isHidden = true
        self.playerFillMode = .resizeAspect
    }

    deinit {
        self.player?.pause()
        self.player = nil
    }

}

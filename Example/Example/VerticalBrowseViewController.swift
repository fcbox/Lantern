//
//  VerticalBrowseViewController.swift
//  Example
//
//  Created by JiongXing on 2019/12/13.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern
import AVKit

class VerticalBrowseViewController: BaseCollectionViewController {
    
    override var name: String { "竖向浏览视频" }
    
    override var remark: String { "抖音的浏览方式" }
    
    override func makeDataSource() -> [ResourceModel] {
        var result: [ResourceModel] = []
        (0..<6).forEach { index in
            let model = ResourceModel()
            model.localName = "video_\(index % 3)"
            result.append(model)
        }
        return result
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let url = Bundle.main.url(forResource: self.dataSource[indexPath.item].localName, withExtension: "MP4") {
            cell.imageView.image = self.getVideoCropPicture(videoUrl: url)
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        // 指定滑动方向为垂直
        lantern.scrollDirection = .vertical
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.cellClassAtIndex = { index in
            VideoCell.self
        }
        lantern.reloadCellAtIndex = { context in
            LanternLog.high("reload cell!")
            let resourceName = self.dataSource[context.index].localName!
            let lanternCell = context.cell as? VideoCell
            if let url = Bundle.main.url(forResource: resourceName, withExtension: "MP4") {
                lanternCell?.player.replaceCurrentItem(with: AVPlayerItem(url: url))
            }
        }
        lantern.cellWillAppear = { cell, index in
            LanternLog.high("开始播放")
            (cell as? VideoCell)?.player.play()
        }
        lantern.cellWillDisappear = { cell, index in
            LanternLog.high("暂停播放")
            (cell as? VideoCell)?.player.pause()
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        lantern.pageIndex = indexPath.item
        lantern.show()
    }
    // MARK: 获取视频预览图
    fileprivate func getVideoCropPicture(videoUrl: URL) -> UIImage? {
        let avAsset = AVURLAsset(url: videoUrl)
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
        if let imageP = try? generator.copyCGImage(at: time, actualTime: &actualTime) {
            return UIImage(cgImage: imageP)
        }
        return nil
    }
}

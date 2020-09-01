//
//  VideoPhotoViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern
import AVKit

class VideoPhotoViewController: BaseCollectionViewController {
    
    override var name: String { "视频与图片混合浏览" }
    
    override var remark: String { "微信我的相册浏览方式" }
    
    override func makeDataSource() -> [ResourceModel] {
        var result: [ResourceModel] = []
        (0..<6).forEach { index in
            let model = ResourceModel()
            model.localName = index % 2 == 0 ? "video_\(index / 2)" : "local_\(index)"
            result.append(model)
        }
        return result
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if indexPath.item % 2 == 0 {
            if let url = Bundle.main.url(forResource: self.dataSource[indexPath.item].localName, withExtension: "MP4") {
                cell.imageView.image = self.getVideoCropPicture(videoUrl: url)
            }
        } else {
            cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
            
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.cellClassAtIndex = { index in
            index % 2 == 0 ? VideoCell.self : LanternImageCell.self
        }
        lantern.reloadCellAtIndex = { context in
            LanternLog.high("reload cell!")
            let resourceName = self.dataSource[context.index].localName!
            if context.index % 2 == 0 {
                let lanternCell = context.cell as? VideoCell
                if let url = Bundle.main.url(forResource: resourceName, withExtension: "MP4") {
                    lanternCell?.player.replaceCurrentItem(with: AVPlayerItem(url: url))
                }
            } else {
                let lanternCell = context.cell as? LanternImageCell
                lanternCell?.imageView.image = UIImage(named: resourceName)
            }
        }
        lantern.cellWillAppear = { cell, index in
            if index % 2 == 0 {
                LanternLog.high("开始播放")
                (cell as? VideoCell)?.player.play()
            }
        }
        lantern.cellWillDisappear = { cell, index in
            if index % 2 == 0 {
                LanternLog.high("暂停播放")
                (cell as? VideoCell)?.player.pause()
            }
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

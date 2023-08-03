//
//  VideoPhotoViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit
import Lantern
import AVKit

class VideoPhotoViewController: BaseCollectionViewController {
    
    override var name: String { "视频与图片混合浏览" }
    
    override var remark: String { "微信我的相册浏览方式" }
    
    let videoUrl = "https://vd2.bdstatic.com/mda-pcdktpwdmxw5vk0n/cae_h264/1678805071714276645/mda-pcdktpwdmxw5vk0n.mp4?abtest=peav_l52&appver=&auth_key=1680752204-0-0-dca00fd02bcb2a9797dbb24c00fccb06&bcevod_channel=searchbox_feed&cd=0&cr=0&did=cfcd208495d565ef66e7dff9f98764da&logid=404179787&model=&osver=&pd=1&pt=4&sl=426&sle=1&split=386564&vid=2482905209255354956&vt=1"
    let videoImage = "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7usmc8j20i543zngx.jpg"
    override func makeDataSource() -> [ResourceModel] {
        var result: [ResourceModel] = []
        (0..<4).forEach { index in
            let model = ResourceModel()
            model.localName = index % 2 == 0 ? "video_\(index / 2)" : "local_\(index)"
            result.append(model)
        }
        return result
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if indexPath.item % 2 == 0 {
            if let url = Bundle.main.url(forResource: self.dataSource[indexPath.item].localName, withExtension: "MP4") {
                cell.imageView.image = self.getVideoCropPicture(videoUrl: url)
                cell.playButtonView.isHidden = false
            }
        } else {
            cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
            
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.pageIndex = indexPath.item
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        lantern.cellClassAtIndex = { index in
            LanternPhotoVideoCell.self
        }
        lantern.reloadCellAtIndex = { context in
            LanternLog.high("reload cell!")
            let lanternCell = context.cell as? LanternPhotoVideoCell
            if let url = Bundle.main.url(forResource: self.dataSource[context.index].localName, withExtension: "MP4") {
                lanternCell?.imageView.image = self.getVideoCropPicture(videoUrl: url)
                lanternCell?.isVideo = false
                lanternCell?.refreshPlayer()
                if context.currentIndex == context.index {
                    lanternCell?.showPlayer(url: url)
                }
            } else {
                lanternCell?.isVideo = false
                lanternCell?.imageView.image = self.dataSource[context.index].localName.flatMap { UIImage(named: $0) }
            }
        }
        
        lantern.cellWillDisappear = { cell, index in
            if index % 2 == 0 {
                LanternLog.high("暂停播放")
                (cell as? LanternPhotoVideoCell)?.player.pause()
            }
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
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

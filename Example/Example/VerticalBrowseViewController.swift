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
        cell.backgroundColor = .red
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
}

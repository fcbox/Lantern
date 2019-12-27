//
//  LocalImageSmoothZoomViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/28.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern

class LocalImageSmoothZoomViewController: BaseCollectionViewController {
    
    override var name: String { "更丝滑的Zoom转场动画" }
    
    override var remark: String { "需要用户自己创建并提供转场视图，以及缩略图位置" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        // 等比拉伸，填满视图
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.reloadCellAtIndex = { context in
            let lanternCell = context.cell as? LanternImageCell
            let indexPath = IndexPath(item: context.index, section: indexPath.section)
            lanternCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        }
        // 更丝滑的Zoom动画
        lantern.transitionAnimator = LanternSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> LanternSmoothZoomAnimator.TransitionViewAndFrame? in
            let path = IndexPath(item: index, section: indexPath.section)
            guard let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell else {
                return nil
            }
            let image = cell.imageView.image
            let transitionView = UIImageView(image: image)
            transitionView.contentMode = cell.imageView.contentMode
            transitionView.clipsToBounds = true
            let thumbnailFrame = cell.imageView.convert(cell.imageView.bounds, to: destinationView)
            return (transitionView, thumbnailFrame)
        })
        lantern.pageIndex = indexPath.item
        lantern.show(method: .push(inNC: nil))
    }
}

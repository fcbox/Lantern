//
//  LongImageViewController.swift
//  Example
//
//  Created by 小豌先生 on 2022/6/13.
//  Copyright © 2022 Shenzhen Hive Box Technology Co.,Ltd. All rights reserved.
//

import UIKit
import Lantern
import Kingfisher

class LongImageViewController: BaseCollectionViewController {
    
    override var name: String { "长图显示动画效果" }
    
    override var remark: String { "长图加载网络图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeNetworkDataSource("LongPhotos")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        lantern.reloadCellAtIndex = { context in
            let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
            let lanternCell = context.cell as? LanternImageCell
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            // 用Kingfisher加载
            lanternCell?.imageView.kf.setImage(with: url, placeholder: placeholder)
        }
        // 针对长图显示动画闪动问题，使用LanternSmoothZoomAnimator动画，回传cell的imageView
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
        lantern.show()
    }
}

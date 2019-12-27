//
//  KingfisherImageViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/28.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern
import Kingfisher

class KingfisherImageViewController: BaseCollectionViewController {
    
    override var name: String { "网络图片-Kingfisher" }
    
    override var remark: String { "举例如何用Kingfisher加载网络图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeNetworkDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.reloadCellAtIndex = { context in
            let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
            let lanternCell = context.cell as? LanternImageCell
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            // 用Kingfisher加载
            lanternCell?.imageView.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { _ in
                lanternCell?.setNeedsLayout()
            })
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

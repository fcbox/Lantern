//
//  GIFViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern
import SDWebImage
import Kingfisher

class GIFViewController: BaseCollectionViewController {
    
    override var name: String { "加载GIF图片" }
    
    override var remark: String { "举例如何用SDWebImage加载GIF网络图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        let models = makeNetworkDataSource()
        models[3].secondLevelUrl = "https://github.com/JiongXing/PhotoBrowser/raw/master/Assets/gifImage.gif"
        models[4].secondLevelUrl = "https://gss3.bdstatic.com/7Po3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D500/sign=51eb2484a1af2eddd0f149e9bd120102/48540923dd54564eb5babebbbede9c82d0584f50.jpg"
        return models
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.sd_setImage(with: url, completed: nil)
            //cell.imageView.kf.setImage(with: url)
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
            // 用SDWebImage加载
            lanternCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                lanternCell?.setNeedsLayout()
            })
            // Kingfisher
            /*lanternCell?.imageView.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { _ in
                lanternCell?.setNeedsLayout()
            })*/
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

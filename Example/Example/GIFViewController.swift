//
//  GIFViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit
import Lantern
import SDWebImage
import Kingfisher

class GIFViewController: BaseCollectionViewController {
    
    override var name: String { "加载GIF图片" }
    
    override var remark: String { "举例如何用SDWebImage加载GIF网络图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        let array = ["http://5b0988e595225.cdn.sohucs.com/images/20171202/0c9fe83abea54a4687503da30c4254be.gif",
                     "https://att.3dmgame.com/att/album/201607/12/172044b6eqtn4zt0i5j1i8.gif",
                     "http://5b0988e595225.cdn.sohucs.com/images/20180507/87e71c4ea00840daba4737bd8172ed97.gif"]
        var result: [ResourceModel] = []
        array.forEach { item in
            let model = ResourceModel()
            model.firstLevelUrl = item
            result.append(model)
        }
        return result
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
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.reloadCellAtIndex = { context in
            let url = self.dataSource[context.index].firstLevelUrl.flatMap { URL(string: $0) }
            let lanternCell = context.cell as? LanternImageCell
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            // Kingfisher
            lanternCell?.imageView.kf.setImage(with: url, placeholder: placeholder)
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

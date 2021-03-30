//
//  LocalImageViewController.swift
//  Example
//
//  Created by JiongXing on 2018/10/14.
//  Copyright © 2021 丰巢科技. All rights reserved.
//

import UIKit
import Lantern

class LocalImageViewController: BaseCollectionViewController {
    
    override var name: String { "本地图片" }
    
    override var remark: String { "最简单的场景，展示本地图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        // 实例化
        let lantern = Lantern()
        // 浏览过程中实时获取数据总量
        lantern.numberOfItems = {
            self.dataSource.count
        }
        // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
        lantern.reloadCellAtIndex = { context in
            let lanternCell = context.cell as? LanternImageCell
            let indexPath = IndexPath(item: context.index, section: indexPath.section)
            lanternCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        }
        // 可指定打开时定位到哪一页
        lantern.pageIndex = indexPath.item
        // 展示
        lantern.show()
    }
}

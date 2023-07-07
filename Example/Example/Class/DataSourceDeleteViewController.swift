//
//  DataSourceDeleteViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/28.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit
import Lantern

class DataSourceDeleteViewController: BaseCollectionViewController {

    override var name: String { "删除图片-长按事件" }
    
    override var remark: String { "浏览过程中删除图片，变更数据源，刷新UI。长按删除。" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        lantern.reloadCellAtIndex = { context in
            guard let lanternCell = context.cell as? LanternImageCell else {
                return
            }
            let indexPath = IndexPath(item: context.index, section: indexPath.section)
            // 必须从数据源取数据，不能取collectionCell的imageView里的图片，
            // 在更改数据源后即使reloadData，也可能取不到，因为UIImageView的图片需要一个更新周期。
            lanternCell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
            lanternCell.index = context.index
            // 添加长按事件
            lanternCell.longPressedAction = { cell, _ in
                self.longPress(cell: cell)
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
    
    private func longPress(cell: LanternImageCell) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
            self.dataSource.remove(at: cell.index)
            self.collectionView.reloadData()
            cell.lantern?.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        cell.lantern?.present(alert, animated: true, completion: nil)
    }
}


//
//  PushNextViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2021 丰巢科技. All rights reserved.
//

import UIKit
import Lantern

class PushNextViewController: BaseCollectionViewController {

    override var name: String { "带导航栏Push" }
    
    override var remark: String { "让lantern嵌入导航控制器里，Push到下一页" }
    
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
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.reloadCellAtIndex = { context in
            guard let lanternCell = context.cell as? LanternImageCell else {
                return
            }
            let indexPath = IndexPath(item: context.index, section: indexPath.section)
            lanternCell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
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
        // 让lantern嵌入当前的导航控制器里
        lantern.show(method: .push(inNC: nil))
    }
    
    private func longPress(cell: LanternImageCell) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "查看详情", style: .destructive, handler: { _ in
            let detail = MoreDetailViewController()
            cell.lantern?.navigationController?.pushViewController(detail, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        cell.lantern?.present(alert, animated: true, completion: nil)
    }
}

//
//  LoadingProgressViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/29.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit
import Lantern
import SDWebImage

class LoadingProgressViewController: BaseCollectionViewController {
    
    override var name: String { "网络图片显示加载进度" }
    
    override var remark: String { "举例如何通过自定义UI显示图片的加载进度" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeNetworkDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        // 使用自定义的Cell
        lantern.cellClassAtIndex = { _ in
            LoadingImageCell.self
        }
        lantern.reloadCellAtIndex = { context in
            let lanternCell = context.cell as? LoadingImageCell
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            lanternCell?.reloadData(placeholder: placeholder, urlString: self.dataSource[context.index].secondLevelUrl)
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

/// 加上进度环的Cell
class LoadingImageCell: LanternImageCell {
    /// 进度环
    let progressView = LanternProgressView()
    
    override func setup() {
        super.setup()
        addSubview(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    func reloadData(placeholder: UIImage?, urlString: String?) {
        progressView.progress = 0
        let url = urlString.flatMap { URL(string: $0) }
        imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], progress: { [weak self] (received, total, _) in
            if total > 0 {
                self?.progressView.progress = CGFloat(received) / CGFloat(total)
            }
        }) { [weak self] (_, error, _, _) in
            self?.progressView.progress = error == nil ? 1.0 : 0
            self?.setNeedsLayout()
        }
    }
}

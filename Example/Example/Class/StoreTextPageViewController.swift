//
//  StoreTextPageViewController.swift
//  Example
//
//  Created by 肖志斌 on 2023/8/3.
//  Copyright © 2023 Shenzhen Hive Box Technology Co.,Ltd. All rights reserved.
//

import UIKit
import Lantern

class StoreTextPageViewController: BaseCollectionViewController {
    
    override var name: String { "商品评价样式预览" }
    
    override var remark: String { "举例如何使用商品评价样式预览UI" }
    
    private var infoView = UIView()
    
    private func addInfoView() {
        let infoView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height - 160, width: self.view.bounds.width, height: 160))
        infoView.backgroundColor = .black
        infoView.isUserInteractionEnabled = false
        let dateLab = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.view.bounds.width, height: 40))
        dateLab.text = "2023.08.02"
        dateLab.font = .systemFont(ofSize: 16, weight: .ultraLight)
        dateLab.textColor = .white
        let infoLab = UILabel.init(frame: CGRect.init(x: 20, y: 40, width: self.view.bounds.width, height: 40))
        infoLab.text = "举例如何使用商品评价样式预览UI"
        infoLab.font = .systemFont(ofSize: 16, weight: .thin)
        infoLab.textColor = .white
        infoView.addSubview(dateLab)
        infoView.addSubview(infoLab)
        self.infoView = infoView
    }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        self.addInfoView()
        let lantern = Lantern()
        lantern.browserView.addSubview(self.infoView)
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        lantern.reloadCellAtIndex = { context in
            let lanternCell = context.cell as? LanternImageCell
            let indexPath = IndexPath(item: context.index, section: indexPath.section)
            lanternCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
            lanternCell?.panGestureEndAction = {[weak self](_, isEnd) in
                self?.infoView.isHidden = isEnd
            }
            lanternCell?.panGestureChangeAction = {[weak self](_, scale) in
                self?.infoView.isHidden = scale < 0.99
            }
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        // 数字样式的页码指示器
        lantern.pageIndicator = LanternNumberPageIndicator()
        lantern.pageIndex = indexPath.item
        lantern.show()
    }
}


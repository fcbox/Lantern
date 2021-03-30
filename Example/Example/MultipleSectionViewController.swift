//
//  MultipleSectionViewController.swift
//  Example
//
//  Created by JiongXing on 2019/12/6.
//  Copyright © 2021 丰巢科技. All rights reserved.
//

import UIKit
import Lantern
import Kingfisher

class MultipleSectionViewController: BaseCollectionViewController {
    
    override var name: String { "多Section场景" }
    
    override var remark: String { "举例如何做跨Section浏览" }
    
    var sections = [[ResourceModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(makeLocalDataSource())
        sections.append(makeNetworkDataSource())
        sections.append(makeLocalDataSource())
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        let model = sections[indexPath.section][indexPath.item]
        if let urlString = model.firstLevelUrl {
            cell.imageView.kf.setImage(with: URL(string: urlString))
        } else if let localName = model.localName {
            cell.imageView.image = UIImage(named: localName)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let lantern = Lantern()
        // 图片总数
        lantern.numberOfItems = {
            return self.sections.reduce(0) { (result, modelArray) -> Int in
                result + modelArray.count
            }
        }
        // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
        lantern.reloadCellAtIndex = { context in
            let (indexPath, model) = self.indexPathFor(LanternIndex: context.index)
            let collectionCell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            let lanternCell = context.cell as? LanternImageCell
            if let urlString = model.secondLevelUrl {
                let url = URL(string: urlString)
                lanternCell?.imageView.kf.setImage(with: url, placeholder: placeholder)
            } else if let localName = model.localName {
                lanternCell?.imageView.image = UIImage(named: localName)
            }
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let (path, _) = self.indexPathFor(LanternIndex: index)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        // 指定打开时定位到哪一页
        lantern.pageIndex = LanternIndexFor(indexPath: indexPath)
        // 展示
        lantern.show()
    }
    
    /// 计算所浏览图片处于哪个section哪个item
    private func indexPathFor(LanternIndex: Int) -> (IndexPath, ResourceModel) {
        var section = 0, count = 0
        for modelArray in sections {
            var item = 0
            for model in modelArray {
                if count == LanternIndex {
                    return (IndexPath(item: item, section: section), model)
                }
                count += 1
                item += 1
            }
            section += 1
        }
        fatalError("所浏览的图片(index:\(LanternIndex))找不到其在前向页面的位置！")
    }
    
    /// 计算IndexPath对应第几张图片
    private func LanternIndexFor(indexPath: IndexPath) -> Int {
        var section = 0, count = 0
        for modelArray in sections {
            var item = 0
            for _ in modelArray {
                if section == indexPath.section && item == indexPath.item {
                    return count
                }
                count += 1
                item += 1
            }
            section += 1
        }
        fatalError("无法计算\(indexPath)对应的图片序号！")
    }
}

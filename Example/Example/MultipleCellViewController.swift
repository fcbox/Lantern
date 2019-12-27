//
//  MultipleCellViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import Lantern

class MultipleCellViewController: BaseCollectionViewController {
    
    override var name: String { "多种类视图" }
    
    override var remark: String { "支持不同的类作为项视图，如在最后一页显示更多推荐" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {
            self.dataSource.count + 1
        }
        lantern.cellClassAtIndex = { index in
            if index < self.dataSource.count {
                return LanternImageCell.self
            }
            return MoreCell.self
        }
        lantern.reloadCellAtIndex = { context in
            if context.index < self.dataSource.count {
                let lanternCell = context.cell as? LanternImageCell
                let indexPath = IndexPath(item: context.index, section: indexPath.section)
                lanternCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
            }
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            if index < self.dataSource.count {
                let path = IndexPath(item: index, section: indexPath.section)
                let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
                return cell?.imageView
            }
            return nil
        })
        lantern.pageIndex = indexPath.item
        lantern.show()
    }
}

class MoreCell: UIView, LanternCell {
    
    weak var lantern: Lantern?
    
    static func generate(with lantern: Lantern) -> Self {
        let instance = Self.init(frame: .zero)
        instance.lantern = lantern
        return instance
    }
    
    var onClick: (() -> Void)?
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("  更多 +  ", for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        return btn
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(button)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.sizeToFit()
        button.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    @objc private func click() {
        lantern?.dismiss()
    }
}

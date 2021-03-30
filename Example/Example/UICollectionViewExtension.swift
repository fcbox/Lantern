//
//  UICollectionViewExtension.swift
//  Example
//
//  Created by 肖志斌 on 2021/3/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

extension UICollectionView: NamespaceWrappable {}

extension TypeWrapperProtocol where WrappedType == UICollectionView {
    
    /// 注册Cell
    public func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = String(describing: type.self)
        wrappedValue.register(type, forCellWithReuseIdentifier: identifier)
    }
    
    /// 取重用Cell
    public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        guard let cell = wrappedValue.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(type.self) was not registered")
        }
        return cell
    }
}

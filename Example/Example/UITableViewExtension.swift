//
//  UITableViewExtension.swift
//  Example
//
//  Created by 肖志斌 on 2021/3/26.
//  Copyright © 2021 丰巢科技. All rights reserved.
//

import UIKit

extension UITableView: NamespaceWrappable {}

extension TypeWrapperProtocol where WrappedType == UITableView {
    /// 注册Cell
    public func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type.self)
        wrappedValue.register(type, forCellReuseIdentifier: identifier)
    }

    /// 取重用Cell
    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
        let identifier = String(describing: type.self)
        guard let cell = wrappedValue.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("\(type.self) was not registered")
        }
        return cell
    }
}

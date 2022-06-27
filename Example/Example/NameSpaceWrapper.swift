//
//  NameSpaceWrapper.swift
//  Example
//
//  Created by 小豌先生 on 2021/3/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import Foundation

/// 类型协议
public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

/// 命名空间协议
public protocol NamespaceWrappable {
    associatedtype WrapperType
    var fc: WrapperType { get }
    static var fc: WrapperType.Type { get }
}



extension NamespaceWrappable {
    public var fc: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    public static var fc: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

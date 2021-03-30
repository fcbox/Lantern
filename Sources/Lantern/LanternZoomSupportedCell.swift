//
//  LanternZoomSupportedCell.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/22.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

/// 在Zoom转场时使用
public protocol LanternZoomSupportedCell: UIView {
    /// 内容视图
    var showContentView: UIView { get }
}

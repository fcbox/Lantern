//
//  LanternCell.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

public protocol LanternCell: UIView {
    
    static func generate(with lantern: Lantern) -> Self
}

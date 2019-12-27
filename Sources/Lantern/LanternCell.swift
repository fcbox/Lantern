//
//  LanternCell.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2019 FengChao. All rights reserved.
//

import UIKit

public protocol LanternCell: UIView {
    
    static func generate(with lantern: Lantern) -> Self
}

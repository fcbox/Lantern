//
//  LanternPageIndicator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2019 FengChao. All rights reserved.
//

import UIKit

public protocol LanternPageIndicator: UIView {
    
    func setup(with lantern: Lantern)
    
    func reloadData(numberOfItems: Int, pageIndex: Int)
    
    func didChanged(pageIndex: Int)
}

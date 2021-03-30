//
//  LanternNoneAnimator.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

/// 使用本类以实现不出现转场动画的需求
open class LanternNoneAnimator: LanternFadeAnimator {
    
    public override init() {
        super.init()
        showDuration = 0
        dismissDuration = 0
    }
}

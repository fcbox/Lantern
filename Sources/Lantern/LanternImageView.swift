//
//  LanternImageView.swift
//  Lantern
//
//  Created by 肖志斌 on 2021/3/25.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

public typealias ImageDidChangedHandler = () -> Void

public protocol LanternImageViewType: UIImageView {

    var imageDidChangedHandler: ImageDidChangedHandler? { get set }
}

public class LanternImageView: UIImageView, LanternImageViewType {

    public var imageDidChangedHandler: (() -> ())?

    public override var image: UIImage? {
        didSet {
            imageDidChangedHandler?()
        }
    }

}

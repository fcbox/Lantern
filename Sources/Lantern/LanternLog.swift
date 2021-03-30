//
//  LanternLog.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/12.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import Foundation

public struct LanternLog {
    
    /// 日志重要程度等级
    public enum Level: Int {
        case low = 0
        case middle
        case high
        case forbidden
    }
    
    /// 允许输出日志的最低等级。`forbidden`为禁止所有日志
    public static var minimumLevel: Level = .forbidden
    
    public static func low(_ item: @autoclosure () -> Any) {
        if minimumLevel.rawValue <= Level.low.rawValue {
            print("[Lantern] [low]", item())
        }
    }
    
    public static func middle(_ item: @autoclosure () -> Any) {
        if minimumLevel.rawValue <= Level.middle.rawValue {
            print("[Lantern] [middle]", item())
        }
    }
    
    public static func high(_ item: @autoclosure () -> Any) {
        if minimumLevel.rawValue <= Level.high.rawValue {
            print("[Lantern] [high]", item())
        }
    }
}

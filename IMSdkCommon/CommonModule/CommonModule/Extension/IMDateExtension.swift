//
//  TmDateExtension.swift
//  TMM
//
//  Created by  on 2021/8/5.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation

public extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Int(millisecond)
    }
}

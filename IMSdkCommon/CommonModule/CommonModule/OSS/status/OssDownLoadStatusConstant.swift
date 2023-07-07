//
//  OssDownLoadStatusConstant.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation
import HandyJSON


//enum OssDownLoadStatusConstant: Int, HandyJSONEnum {
//    case ORIGIN = 0
//    case WAIT = 1
//    case DOWNLOADING = 2
//    case SUCCESS = 3
//    case FAILED = 4
//    case PAUSE = 5
//}

public enum OssDownLoadStatusConstant: Int, HandyJSONEnum {
    case progress = 0
    case success = 1
    case defult = 4
    case wait = 6
    case pause = 7
    case fail = 8
}

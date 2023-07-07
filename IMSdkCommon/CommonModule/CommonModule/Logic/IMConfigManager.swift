//
//  IMConfigManager.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/16.
//

import Foundation

@objcMembers public class IMConfigManager: NSObject {

    static public var `default` = IMConfigManager()

    public var isFlowDown = false
    
    public func getOssStaus(progress: Int) -> Int {
        let s = progress / 100
        return s
    }
    
    public func getOssProgress(progress: Int) -> Int {
        let s = progress % 100
        return s
    }
    
    public func synthesisProgress(progress: Int, status: Int) -> Int {
        
        return status * 100 + progress
    }
    
    public func determineIsLargeFile(length: Int) -> IMTransferFileSizeType {
        
        if length >= 100 * 1024 {
            return IMTransferFileSizeType.big
        }
        
        return IMTransferFileSizeType.small
    }
}

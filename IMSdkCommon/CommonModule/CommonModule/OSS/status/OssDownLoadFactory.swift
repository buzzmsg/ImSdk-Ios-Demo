//
//  OssDownLoadFactory.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation


@objcMembers public class OssDownLoadFactory : NSObject {
    //840
    func create(status: Int, oss: IMOSS, bucketId: String, sizeType: IMTransferFileSizeType, isNeedNotice : Int = 1) -> OssDownLoadStatus {
        
        if IMConfigManager.default.getOssStaus(progress: status) == OssDownLoadStatusConstant.progress.rawValue { //downloading
            return DownLoadingOssStatus.init(status: status,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice)
        }
        
        if IMConfigManager.default.getOssStaus(progress: status) == OssDownLoadStatusConstant.success.rawValue { //success
            return DownLoadSuccessOssStatus.init(status: status,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice)
        }
        
        if IMConfigManager.default.getOssStaus(progress: status) == OssDownLoadStatusConstant.wait.rawValue { //wait
            return WaitDownLoadOssStatus.init(status: status,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice)
        }
        
        if IMConfigManager.default.getOssStaus(progress: status) == OssDownLoadStatusConstant.pause.rawValue { //pause
            return DownLoadPauseOssStatus.init(status: status,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice)
        }
        
        if IMConfigManager.default.getOssStaus(progress: status) == OssDownLoadStatusConstant.fail.rawValue { //fail
            return DownLoadFailedOssStatus.init(status: status,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice)
        }
        
        return DefaultDownLoadOssStatus.init(status: OssDownLoadStatusConstant.defult.rawValue,oss: oss, bucketId: bucketId, sizeType: sizeType, isNeedNotice :isNeedNotice) //defult
    }
    
    public func createDisplay(status: Int) -> OssDownLoadDisplayStatus {
        switch status {
        case OssDownLoadStatusConstant.defult.rawValue:
            
            return DefaultDownLoadOssDisplayStatus.init(status: status)
        case OssDownLoadStatusConstant.wait.rawValue:
            
            return DownLoadingOssDisplayStatus.init(status: status)
        case OssDownLoadStatusConstant.progress.rawValue:
            
            return DownLoadingOssDisplayStatus.init(status: status)
        case OssDownLoadStatusConstant.success.rawValue:
            
            return DownLoadSuccessOssDisplayStatus.init(status: status)
        case OssDownLoadStatusConstant.fail.rawValue:
            
            return DownLoadFailedOssDisplayStatus.init(status: status)
        case OssDownLoadStatusConstant.pause.rawValue:
            
            return DownLoadPauseOssDisplayStatus.init(status: status)
        default:
            return DefaultDownLoadOssDisplayStatus.init(status: status)
        }
    }
    
}

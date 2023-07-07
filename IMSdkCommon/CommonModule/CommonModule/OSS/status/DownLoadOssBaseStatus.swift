//
//  DownLoadOssBaseStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DownLoadOssBaseStatus : OssDownLoadStatus {
    
    @discardableResult
    func startDownload(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func grabDownload(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func pause(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func delete(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func failed(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func overTime(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func channelGrabbed(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func success(objectId: String) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    @discardableResult
    func getDownloadProgress() -> Int {
        return self.status
    }
    
    @discardableResult
    func releaseChannel(objectId: String, timeStamp: Int) -> Promise<OssDownLoadStatus> {
        return Promise<OssDownLoadStatus>.resolve(self)
    }
    
    var oss: IMOSS!
    var status:Int = 0
    var bucketId:String = ""
    var sizeType: IMTransferFileSizeType = IMTransferFileSizeType.small
    var isNeedNotice: Int = 1
    
    init(status: Int, oss: IMOSS, bucketId: String, sizeType: IMTransferFileSizeType, isNeedNotice: Int) {
        self.oss = oss
        self.status = status
        self.isNeedNotice = isNeedNotice
        self.bucketId = bucketId
        self.sizeType = sizeType
    }
    
}

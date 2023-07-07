//
//  DownLoadFailedOssDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DownLoadFailedOssStatus: DownLoadOssBaseStatus {
    
    @discardableResult
    override func startDownload(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<OssDownLoadStatus> in
                guard let model = progressModel else {
                    
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.progress = IMTransferProgressState.wait.rawValue
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: IMTransferProgressState.wait.rawValue, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.wait.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: lp, timeStamp: Date().milliStamp, retryCount: 0).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
    
    @discardableResult
    override func grabDownload(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<OssDownLoadStatus> in
                guard let model = progressModel else {
                    
                    let statusVal: Int = IMTransferProgressState.start.rawValue
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.progress = statusVal
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: statusVal, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.progress.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: lp, retryCount: 0).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
    
    @discardableResult
    override func success(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<OssDownLoadStatus> in
                guard let model = progressModel else {
                    
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.progress = IMTransferProgressState.success.rawValue
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: IMTransferProgressState.success.rawValue, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        self.oss.deleagte?.updateFileBusinessSuccess(objectId: objectId)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.success.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgressOnStart(objectId: objectId, progress: lp).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                    self.oss.deleagte?.updateFileBusinessSuccess(objectId: objectId)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
}

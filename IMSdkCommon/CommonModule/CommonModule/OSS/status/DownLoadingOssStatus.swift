//
//  DownLoadingOssDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DownLoadingOssStatus: DownLoadOssBaseStatus {
    
    @discardableResult
    override func pause(objectId: String) -> Promise<OssDownLoadStatus> {
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
                    fileProgressModel.progress = IMTransferProgressState.pausedMin.rawValue
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: IMTransferProgressState.pausedMin.rawValue, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.pause.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgressOnStart(objectId: objectId, progress: lp).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
    
    @discardableResult
    override func failed(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<OssDownLoadStatus> in
                let statusVal: Int = IMTransferProgressState.wait.rawValue
                guard let model = progressModel else {
                    
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.progress = statusVal
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = kMinTime
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: statusVal, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                
                if model.retryCount < kRetryDownloadMaxCount {
                    let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                    var lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.wait.rawValue)
                    let retryCount: Int = model.retryCount + 1
                    return IMFileProgressDao(db: dataBase).updateProgressOnWaitToOrderLast(objectId: objectId, progress: lp, retryCount: retryCount).then { v -> Promise<OssDownLoadStatus> in
                        
                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectId)")
                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.oss.ossContext.nc)
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [objectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        
                        let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        self.oss.deleagte?.updateFileBusinessFailed(objectId: objectId, progress: st.getDownloadProgress())

                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                
                let progress: Int = IMTransferProgressState.failedMin.rawValue
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: progress, retryCount: 0).then { v -> Promise<OssDownLoadStatus> in
                    
                    SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectId)")
                    let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.oss.ossContext.nc)
                    let fileDownloadEvent = IMFileDownloadEvent()
                    fileDownloadEvent.objectIds = [objectId]
                    notificationManager.post(eventProtocol: fileDownloadEvent)
                    self.oss?.deleagte?.updateFileBusinessFailed(objectId: objectId, progress: progress)
                    
                    let st = OssDownLoadFactory().create(status: progress, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
    
    @discardableResult
    override func channelGrabbed(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<Int> in
                guard let model = progressModel else {
                    
                    let statusVal: Int = IMTransferProgressState.wait.rawValue
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.progress = statusVal
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<Int> in
                        return Promise<Int>.resolve(statusVal)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.wait.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgressOnWaitToOrderFirst(objectId: objectId, progress: lp, retryCount: 0).then { v -> Promise<Int> in
                    return Promise<Int>.resolve(lp)
                }
            }.then { progressVal -> Promise<OssDownLoadStatus> in
                
                SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectId)")
                let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.oss.ossContext.nc)
                let fileDownloadEvent = IMFileDownloadEvent()
                fileDownloadEvent.objectIds = [objectId]
                notificationManager.post(eventProtocol: fileDownloadEvent)
                
                let st = OssDownLoadFactory().create(status: progressVal, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                return Promise<OssDownLoadStatus>.resolve(st)
            }

    }
    
    @discardableResult
    override func success(objectId: String) -> Promise<OssDownLoadStatus> {
        guard let dataBase = self.oss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise<OssDownLoadStatus>.reject(IMNetworkingError.createCommonError())
        }

        SDKDebugLog("3333 --> [\(self) [\(#function)] convert status objectID is \(objectId)!!!")
        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
            .then { progressModel -> Promise<Int> in
                
                let statusVal: Int = IMTransferProgressState.success.rawValue
                guard let _ = progressModel else {
                    
                    var fileProgressModel = IMFileProgressModel()
                    fileProgressModel.sizeType = self.sizeType.rawValue
                    fileProgressModel.bucketId = self.bucketId
                    fileProgressModel.progress = statusVal
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { _ -> Promise<Int> in
                        return Promise<Int>.resolve(statusVal)
                    }
                }
                
                return IMFileProgressDao(db: dataBase).updateProgressOnStart(objectId: objectId, progress: statusVal).then { _ -> Promise<Int> in
                    return Promise<Int>.resolve(statusVal)
                }
            }.then { progressVal -> Promise<OssDownLoadStatus> in
                
                SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectId)")
                let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.oss.ossContext.nc)
                let fileDownloadEvent = IMFileDownloadEvent()
                fileDownloadEvent.objectIds = [objectId]
                notificationManager.post(eventProtocol: fileDownloadEvent)
                
                let st = OssDownLoadFactory().create(status: progressVal, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                self.oss.deleagte?.updateFileBusinessSuccess(objectId: objectId)
                return Promise<OssDownLoadStatus>.resolve(st)
            }
    }
    
    @discardableResult
    override func releaseChannel(objectId: String, timeStamp: Int) -> Promise<OssDownLoadStatus> {
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
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: lp, timeStamp: timeStamp).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
    
    override func delete(objectId: String) -> Promise<OssDownLoadStatus> {
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
                    fileProgressModel.progress = IMTransferProgressState.pausedMin.rawValue
                    fileProgressModel.objectId = objectId
                    fileProgressModel.isNeedNotice = self.isNeedNotice
                    fileProgressModel.createTime = Date().milliStamp
                    
                    return IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [fileProgressModel]).then { v -> Promise<OssDownLoadStatus> in
                        
                        let st = OssDownLoadFactory().create(status: IMTransferProgressState.pausedMin.rawValue, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)
                        return Promise<OssDownLoadStatus>.resolve(st)
                    }
                }
                let p = IMConfigManager.default.getOssProgress(progress: model.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.pause.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: lp).then { v -> Promise<OssDownLoadStatus> in
                    
                    let st = OssDownLoadFactory().create(status: lp, oss: self.oss, bucketId: self.bucketId, sizeType: self.sizeType)

                    return Promise<OssDownLoadStatus>.resolve(st)
                }
            }
    }
}

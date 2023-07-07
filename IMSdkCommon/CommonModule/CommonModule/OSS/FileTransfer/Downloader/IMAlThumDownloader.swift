//
//  IMAlThumDownloader.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import UIKit

class IMAlThumDownloader: IMDownloader {
    
    var lastSendEventTime: Int = 0

    var objectParse: IMImageUrlParse?
    var sourceSence:IMTransferSence = IMTransferSence.IM
    var isNeedNotice = 0
    var ossPath: String = ""
    var ossContext: IMContext = IMContext()
    weak var deleagte: IMOSSDelegate?
    weak var oss: IMOSS?
    var referenceCount: Int = kDefaultReferenceCount

    func download(objectID: String) {
        
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossContext.nc)
        
        if let bid = objectParse?.bucketId {
            /*
            let errorClosure: (() -> ()) = {
                
                let value: Int = IMFileProgressDao(db: dataBase).queryProgressValueNormal(objectId: objectID)
                
                if value == IMTransferProgressState.start.rawValue {
                    
                    let errorProgress: Int = -1
                    IMFileProgressDao(db: dataBase).updateProgressOnError(objectId: objectID, progress: errorProgress).then({ Void -> Promise<Void> in
                        
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [objectID]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        return Promise<Void>.resolve()
                    })
                } else if value > IMTransferProgressState.start.rawValue && value < IMTransferProgressState.success.rawValue {
                    
                    let errorProgress: Int = Int(-abs(value))
                    IMFileProgressDao(db: dataBase).updateProgressOnError(objectId: objectID, progress: errorProgress).then({ Void -> Promise<Void> in
                        
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [objectID]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        return Promise<Void>.resolve()
                    })
                }
            }*/
            let errorClosure: (() -> ()) = {[weak self] in
                guard let self = self else {
                    return
                }
                IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectID).then { modelValue -> Promise<Void> in
                    
                    if let tModel = modelValue {
                        let st = OssDownLoadFactory().create(status: tModel.progress, oss: self.oss!, bucketId: tModel.bucketId, sizeType: IMTransferFileSizeType(rawValue: tModel.sizeType)!)
                        st.failed(objectId: objectID)
                    }else {
                        self.oss?.deleagte?.updateFileBusinessFailed(objectId: objectID, progress: IMTransferProgressState.failedMin.rawValue)
                    }
                    
                    return Promise<Void>.resolve()
                }
            }
            
            
            //IMBucketManager().getBucketInfo(bucketID: bid, context: self.ossContext)
            self.deleagte!.bucketInfo(bucketID: bid)
                .then { (value : IMBucketInfoModel) -> Promise<Void> in
                    
                    guard let b = value.bucketId, b.count > 0 else {
                        
                        errorClosure()
                        return Promise<Void>.resolve()
                    }
                    
                    IMAliCloudApi.shared.downThumbFile(bucketInfoModel: value, objectId: objectID, saveOSSPath: self.ossPath, thumbW: self.objectParse?.thumbWidth ?? 0, thumbH: self.objectParse?.thumbHeight ?? 0) { transferInfo in
                        
                        if transferInfo.fileStatus == IMFileTransferStatus.Download_Success {
                            
//                            IMFileProgressDao(db: dataBase).updateProgress(objectId: objectID, progress: IMTransferProgressState.success.rawValue).then({ Void -> Promise<Void> in
//
//                                let fileDownloadEvent = IMFileDownloadEvent()
//                                fileDownloadEvent.objectIds = [objectID]
//                                notificationManager.post(eventProtocol: fileDownloadEvent)
//                                return Promise<Void>.resolve()
//                            })
                            IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectID).then { modelValue -> Promise<Void> in
                                
                                if let tModel = modelValue {
                                    let st = OssDownLoadFactory().create(status: tModel.progress, oss: self.oss!, bucketId: tModel.bucketId, sizeType: IMTransferFileSizeType(rawValue: tModel.sizeType)!)
                                    st.success(objectId: objectID)
                                }else {
                                    self.oss?.deleagte?.updateFileBusinessSuccess(objectId: objectID)
                                }
                                
                                return Promise<Void>.resolve()
                            }
                            return
                            
                        }
                        
                        if transferInfo.fileStatus == IMFileTransferStatus.Download_Failed {
                            errorClosure()
                            return
                        }
                        
                        if transferInfo.fileStatus == IMFileTransferStatus.Downloading_NoKey {
                            
                            // just special error with aws3, update progress value 404
                            let progress: Int = IMTransferProgressState.failedMin.rawValue
                            IMFileProgressDao(db: dataBase).updateProgress(objectId: objectID, progress: progress, retryCount: 0).then({ Void -> Promise<Void> in
                                
                                SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectID)")
                                let fileDownloadEvent = IMFileDownloadEvent()
                                fileDownloadEvent.objectIds = [objectID]
                                notificationManager.post(eventProtocol: fileDownloadEvent)
                                self.oss?.deleagte?.updateFileBusinessFailed(objectId: objectID, progress: progress)
                                return Promise<Void>.resolve()
                            })
                        }
                        
                        
                        IMFileProgressDao(db: dataBase).updateProgress(objectId: objectID, progress: transferInfo.progress).then({ Void -> Promise<Void> in
                            
                            let sendTime: Int = Date().milliStamp
                            if sendTime - self.lastSendEventTime >= IMOSS.eventSendIntervalTime {
                                
                                //                                SDKDebugLog("send event 2: \(sendTime), progress: \(transferInfo.progress), objectID: \(objectID)")
                                
                                SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectID)")
                                self.lastSendEventTime = sendTime
                                let fileDownloadEvent = IMFileDownloadEvent()
                                fileDownloadEvent.objectIds = [objectID]
                                notificationManager.post(eventProtocol: fileDownloadEvent)
                            }
                            
                            return Promise<Void>.resolve()
                        })
                    }
                    return Promise<Void>.resolve()
                }
        }else {
            print("NO HAVE bucketID,objectID = \(objectID)")
        }
        
    }
        
    func cancel(objectId: String, success: @escaping CancleTaskSuccess) {
        IMAliCloudApi.shared.cancleTask(objectId: objectId)
        success()
    }
    
    func increaseReferenceCount() {
        self.referenceCount += 1
    }
    func reduceReferenceCount() {
        self.referenceCount -= 1
    }
    func getReferenceCount() -> Int {
        return self.referenceCount
    }
    
}

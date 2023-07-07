//
//  IMAlUploader.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import UIKit

class IMAlUploader: IMUploader {
    
    var lastSendEventTime: Int = 0

    func upload(objectID: String) {
        
        //start progress
        let startProgress: Int = IMTransferProgressState.start.rawValue
        self.uploadProgress.startProgress(objectId: objectID, progress: startProgress)
        
        //send event
        let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
        self.ossContext.nc.post(event: uploadEvent)
        
        
        typealias ResultTuple = (String, String)

        //IMBucketManager().getSelfBucketId(context: self.ossContext).then { userSelfBucketID -> Promise<String> in
        self.deleagte!.getSelfBucketId().then { userSelfBucketID -> Promise<String> in
            
            if self.bucketId.isEmpty && userSelfBucketID.isEmpty {
                self.uploadProgress.updateUploadFailureProgress(objectId: objectID)
                let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                self.ossContext.nc.post(event: uploadEvent)
                return Promise<String>.reject(IMNetworkingError.createCommonError())
            }
            
            return Promise<String>.resolve(userSelfBucketID)
            
        }.then { mySelfBucketID -> Promise<ResultTuple> in
            
            var lookupBucketID: String = self.bucketId
            if self.bucketId.isEmpty {
                lookupBucketID = mySelfBucketID
            }
            
            var uploadBucketID: String = mySelfBucketID
            if mySelfBucketID.isEmpty {
                uploadBucketID = self.bucketId
            }
                                    
            //return IMBucketManager().getBucketInfo(bucketID: lookupBucketID, context: self.ossContext).then { bucketInfo -> Promise<ResultTuple> in
            return self.deleagte!.bucketInfo(bucketID: lookupBucketID).then { bucketInfo -> Promise<ResultTuple> in

                guard let bucketName: String = bucketInfo.bucketName, bucketName.count > 0 else {
                    return Promise<ResultTuple>.reject(IMNetworkingError.createCommonError())
                }

                let tupl:ResultTuple  = (lookupBucketID, uploadBucketID)
                return Promise<ResultTuple>.resolve(tupl)
                
                
             }.catch { error -> Promise<ResultTuple> in
                 self.uploadProgress.updateUploadFailureProgress(objectId: objectID)
                 let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                 self.ossContext.nc.post(event: uploadEvent)
                 return Promise<ResultTuple>.reject(error)
             }
            
        }.then { (lookupBucketID, uploadBucketID) -> Promise<Void> in
            
            // will upload
            //return IMBucketManager().getBucketInfo(bucketID: uploadBucketID, context: self.ossContext).then { bucketInfo -> Promise<Void> in
            return self.deleagte!.bucketInfo(bucketID: uploadBucketID).then { bucketInfo -> Promise<Void> in
                
                let path: String = self.ossPath + objectID
                IMAliCloudApi.shared.uploadFile(bucketInfoModel: bucketInfo, filePath: path, objectId: objectID) { transferInfo in

                    if transferInfo.fileStatus == IMFileTransferStatus.Uploading_Failed {
                        self.uploadProgress.updateUploadFailureProgress(objectId: objectID)
                    }
                    
                    if transferInfo.fileStatus == IMFileTransferStatus.Uploading  {
                        let progress: Int = transferInfo.progress
                        self.uploadProgress.updateUploadingProgress(objectId: objectID, progress: progress)
                    }
                    
                    if transferInfo.fileStatus == IMFileTransferStatus.Uploading_Success {
                        let progress: Int = IMTransferProgressState.success.rawValue
                        self.uploadProgress.updateUploadingProgress(objectId: objectID, progress: progress)
                        
                        // The bucketid of this task needs to be updated in the task table
                        self.uploadProgress.updateProgressBucketID(objectId: objectID, bucketID: uploadBucketID)
                    }
                    
                    if transferInfo.fileStatus == IMFileTransferStatus.Uploading {

                        let sendTime: Int = Date().milliStamp
                        if sendTime - self.lastSendEventTime >= IMOSS.eventSendIntervalTime {
                            
//                            SDKDebugLog("send event 3: \(sendTime), progress: \(transferInfo.progress), objectID: \(objectID)")

                            self.lastSendEventTime = sendTime
                            let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                            self.ossContext.nc.post(event: uploadEvent)
                        }
                        return
                    }
                    
                    let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                    self.ossContext.nc.post(event: uploadEvent)
                }
                
                return Promise<Void>.resolve()
            }
            
        }
    }
    
    func cancel(objectID: String, success: @escaping CancleTaskSuccess) {
//        IMAWSUploadDownManager.default.cancleUploadTask(objectID: objectID)
        success()
    }
    
    var bucketId: String
    var ossContext: IMContext
    var ossPath: String
    var uploadProgress: IMFileUploadProgress
    private weak var deleagte: IMOSSDelegate?
    
    init(bucketId: String, ossContext: IMContext, ossPath: String, progress: IMFileUploadProgress, deleagte: IMOSSDelegate?) {
        self.bucketId = bucketId
        self.ossContext = ossContext
        self.ossPath = ossPath
        self.uploadProgress = progress
        self.deleagte = deleagte
    }
}

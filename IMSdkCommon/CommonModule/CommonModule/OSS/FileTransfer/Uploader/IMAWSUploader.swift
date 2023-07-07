//
//  IMAWSUploader.swift
//  TMM
//
//  Created by    on 2022/5/17.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit

class IMAWSUploader: IMUploader {

    func upload(objectID: String) {
        
        //start progress
        let startProgress: Int = IMTransferProgressState.start.rawValue
        self.uploadProgress.startProgress(objectId: objectID, progress: startProgress)
        
        //send event
        let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
        self.ossContext.nc.post(event: uploadEvent)
        
        
        typealias ResultTuple = (Bool, String, String)

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
                
                // Check whether awS3 exists in the resource to be uploaded
//                return IMAWSUploadDownManager.default.objectMaybeExist(buckId: lookupBucketID, buckName: bucketName, objectId: objectID, ossContext: self.ossContext).then {isHave -> Promise<ResultTuple> in
                return self.deleagte!.objectMaybeExist(buckId: lookupBucketID, buckName: bucketName, objectId: objectID).then {isHave -> Promise<ResultTuple> in
                    
                    let tupl:ResultTuple  = (isHave, lookupBucketID, uploadBucketID)
                    return Promise<ResultTuple>.resolve(tupl)
                }
                
             }.catch { error -> Promise<ResultTuple> in
                 self.uploadProgress.updateUploadFailureProgress(objectId: objectID)
                 let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                 self.ossContext.nc.post(event: uploadEvent)
                 return Promise<ResultTuple>.reject(error)
             }
            
        }.then { (isHave, lookupBucketID, uploadBucketID) -> Promise<Void> in
            
            if isHave {
                let progress: Int = IMTransferProgressState.success.rawValue
                self.uploadProgress.updateUploadingProgress(objectId: objectID, progress: progress)
                
                // The bucketid of this task needs to be updated in the task table
                self.uploadProgress.updateProgressBucketID(objectId: objectID, bucketID: lookupBucketID)
                
                let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                self.ossContext.nc.post(event: uploadEvent)
                return Promise<Void>.resolve()
            }
            
            // will upload
            //return IMBucketManager().getBucketInfo(bucketID: uploadBucketID, context: self.ossContext).then { bucketInfo -> Promise<Void> in
            return self.deleagte!.bucketInfo(bucketID: uploadBucketID).then { bucketInfo -> Promise<Void> in
                
                let oss: IMOSS = IMOSS(context: self.ossContext, ossPath: self.ossPath, delegate: self.deleagte!)

                let path: String = self.ossPath + objectID
                IMAWSUploadDownManager.default.uploadFile(bucketInfoModel: bucketInfo, filePath: path, objectId: objectID, saveOSS: oss, deleagte: self.deleagte) { transferInfo in

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
                    
                    let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
                    self.ossContext.nc.post(event: uploadEvent)
                }
                
                return Promise<Void>.resolve()
            }
            
        }
        
        
        
        
        
        
        
        
//        IMBucketManager().getBucketInfo(bucketID: self.bucketId).then { bucketInfo -> Promise<Void> in
//
//            let path: String = IMPathManager.shared.getOssDir() + objectID
//            IMAWSUploadDownManager.default.uploadFile(bucketInfoModel: bucketInfo, filePath: path, objectId: objectID) { transferInfo in
//
//                if transferInfo.fileStatus == IMFileTransferStatus.Uploading_Failed {
//                    IMFileUploadProgress.shared.updateUploadFailureProgress(objectId: objectID)
//                }
//
//                if transferInfo.fileStatus == IMFileTransferStatus.Uploading  {
//                    let progress: Int = transferInfo.progress
//                    IMFileUploadProgress.shared.updateUploadingProgress(objectId: objectID, progress: progress)
//                }
//
//                if transferInfo.fileStatus == IMFileTransferStatus.Uploading_Success {
//                    let progress: Int = TMMTransferProgressState.success.rawValue
//                    IMFileUploadProgress.shared.updateUploadingProgress(objectId: objectID, progress: progress)
//                }
//
//                let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
//                IMNotificationCenter.default.post(event: uploadEvent)
//            }
//
//            return Promise<Void>.resolve()
//        }
    }
    
    func cancel(objectID: String, success: @escaping CancleTaskSuccess) {
        IMAWSUploadDownManager.default.cancleUploadTask(objectID: objectID, success: success)
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

//
//  IMLogUploader.swift
//  TMM
//
//  Created by on 2022/8/23.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit

class IMLogUploader: IMUploader {

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

    func upload(objectID: String) {

        //start progress
        let startProgress: Int = IMTransferProgressState.start.rawValue
        self.uploadProgress.startProgress(objectId: objectID, progress: startProgress)
        
        //send event
        let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
        self.ossContext.nc.post(event: uploadEvent)
        
        //IMBucketManager().getBucketInfo(bucketID: self.bucketId, context: self.ossContext).then { bucketInfo -> Promise<Void> in
        self.deleagte!.bucketInfo(bucketID: self.bucketId).then { bucketInfo -> Promise<Void> in
           
            let path: String = self.ossPath + objectID
            
            let tOss: IMOSS = IMOSS(context: self.ossContext, ossPath: self.ossPath, delegate: self.deleagte!)

            IMAWSUploadDownManager.default.uploadFile(bucketInfoModel: bucketInfo, filePath: path, objectId: objectID, saveOSS: tOss, deleagte: self.deleagte) { transferInfo in

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
                   self.uploadProgress.updateProgressBucketID(objectId: objectID, bucketID: self.bucketId)
               }
               
               let uploadEvent: IMFileUploadEvent = IMFileUploadEvent(objectIds: [objectID])
               self.ossContext.nc.post(event: uploadEvent)
           }
           
           return Promise<Void>.resolve()
       }
    }
    
    func cancel(objectID: String, success: @escaping CancleTaskSuccess) {
        IMAWSUploadDownManager.default.cancleUploadTask(objectID: objectID, success: success)
    }
}

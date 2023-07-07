//
//  IMTransferUploadControler.swift
//  TMM
//
//  Created by  on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

public class IMTransferUploadControler: NSObject {
    
    private var uploaderMap: [String: IMUploader] = [:]

//    static let `shared`: IMTransferUploadControler = {
//        let sha: IMTransferUploadControler = IMTransferUploadControler()
//
//        let observer = Observer(callBack: { (uploadEvent: IMFileUploadEvent, observ: Observer<IMFileUploadEvent>) in
//
//            uploadEvent.objectIds.forEach { objectId in
//
//                let progress: Int = IMFileUploadProgress.shared.getProgress(objectId: objectId)
//
//                let isUploading: Bool = (progress < IMTransferProgressState.success.rawValue &&
//                                         progress >= IMTransferProgressState.start.rawValue)
//                if !isUploading {
//
//                    // cancel task
//                    if let uploader: IMAWSUploader = IMTransferUploadControler.shared.uploaderMap[objectId] {
//                        uploader.cancel(objectID: objectId) {
//
//                            // clean cache uploader
//                            IMTransferUploadControler.shared.uploaderMap.removeValue(forKey: objectId)
//
//                            // clean db progress
//                            IMFileUploadProgress.shared.deleteTask(objectId: objectId)
//
//                            // start wait task
//                            IMTransferUploadControler.shared.uploading()
//                        }
//                    }
//
//                }
//
//            }
//        })
//
//        IMNotificationCenter.default.addObersver(observer: observer, name: IMFileUploadEvent().getName())
//
//        return sha
//
//    }()
    
    var ossContext: IMContext
    var ossPath: String
    var uploadProgress: IMFileUploadProgress
    private var deleagte: IMOSSDelegate?
    
    func setDelegate(del: IMOSSDelegate) {
        self.deleagte = del
    }
    
    init(context: IMContext, ossPath: String) {
        self.ossContext = context
        self.ossPath = ossPath
        self.uploadProgress = IMFileUploadProgress.shared
        super.init()
        
        let observer = IMObserver(callBack: {[weak self] (uploadEvent: IMFileUploadEvent, observ: IMObserver<IMFileUploadEvent>) in
            guard let self = self else { return }
            
            uploadEvent.objectIds.forEach { objectId in
                
                let progress: Int = self.uploadProgress.getProgress(objectId: objectId)
                
                let isUploading: Bool = (progress < IMTransferProgressState.success.rawValue &&
                                         progress >= IMTransferProgressState.start.rawValue)
                if !isUploading {
                    
                    // cancel task
                    if let uploader: IMUploader = self.uploaderMap[objectId] {
                        uploader.cancel(objectID: objectId) {
                            
                            // clean cache uploader
                            self.uploaderMap.removeValue(forKey: objectId)
                            
                            // clean db progress
                            self.uploadProgress.deleteTask(objectId: objectId)
                            
                            // start wait task
                            self.uploading()
                        }
                    }
                    
                }
                
            }
        })
        
        context.nc.addObersver(observer: observer, name: IMFileUploadEvent().getName())
    }
    
    
    
    func uploading() {
        
        let max: Int = getUploadTaskAsyncMaxCount()
        let currentExecuteTaskCount: Int = uploaderMap.count
        if max <= currentExecuteTaskCount {
            return
        }
        let freeCount: Int = max - currentExecuteTaskCount
        let waitTaskArr = self.uploadProgress.getWaitTask(count: freeCount)

        waitTaskArr.forEach { task in

            let objectId: String = task.objectId
            let uploader = uploaderMap[objectId]
            if uploader == nil {
                
                IMTransferFactory.creatUploader(bucketId: task.bucketId, ossContext: ossContext, ossPath: ossPath, progress: uploadProgress, deleagte: self.deleagte).then { newUploader -> Promise<Void> in
                    
                    // promise is asyn excute
                    let uploader = self.uploaderMap[objectId]
                    if uploader == nil {
                        
                        //save uploader
                        self.uploaderMap[objectId] = newUploader
                        
                        //start upload
                        newUploader.upload(objectID: objectId)
                        
                    }
                    
                    return Promise<Void>.resolve()
                }
            }
        }
    }
    
    
    // MARK: -

    private func getUploadTaskAsyncMaxCount() -> Int {
        return 10000
    }
    
    private func releaseTaskAsyncMaxCount(){
       
    }
    
    
    //private override init() {}
    
    public override func copy() -> Any {
        return self
    }
    
    public override func mutableCopy() -> Any {
        return self
    }
    
}

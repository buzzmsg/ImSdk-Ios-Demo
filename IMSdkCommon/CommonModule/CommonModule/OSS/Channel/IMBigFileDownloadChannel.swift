//
//  IMBigFileDownloadChannel.swift
//  CommonModule
//
//  Created by Joey on 2023/5/15.
//

import Foundation
import WCDBSwift


class IMBigFileDownloadChannel: IMBaseDownloadChannel {
    
//    override func next() -> Promise<Void> {
//
//        if self.grabWork.isGarbing() == true {
//            SDKDebugLog("IMBigFileDownloadChannel grabNext is working!")
//            return Promise<Void>.resolve()
//        }
//
//        if self.isNextWork == true {
//            SDKDebugLog("IMBigFileDownloadChannel next is working!")
//            return Promise<Void>.reject(IMNetworkingError.createCommonError())
//        }
//        self.isNextWork = true
//
//        guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
//            self.isNextWork = false
//            dbErrorLog("IMBigFileDownloadChannel [\(#function)] context db is nil")
//            return Promise<Void>.resolve()
//        }
//
//        let max: Int = getTaskAsyncMaxCount()
//        let freeCount: Int = max - downloaders.count
//        if freeCount <= 0 {
//            self.isNextWork = false
//            SDKDebugLog("IMBigFileDownloadChannel no free downloader! current map keys: \(self.downloadingObjectIds())")
//            return Promise<Void>.resolve()
//        }
//
//        return IMFileProgressDao(db: dataBase).queryBigFileWaitProgress(count: freeCount).then { waitProgress -> Promise<Void> in
//
//            if waitProgress.isEmpty {
//                self.isNextWork = false
//                SDKDebugLog("IMBigFileDownloadChannel no wait progress!")
//                return Promise<Void>.resolve()
//            }
//
//            var existObjectIds: [String] = []
////            let docu: String = tOss.ossPath
//
//            var promiseArr: [Promise<Void>] = []
////            var sourceSenceMap: [String: Int] = [:]
//            for prog in waitProgress {
//
//                SDKDebugLog("IMBigFileDownloadChannel wait progress next objectId: \(prog.objectId), status: \(prog.progress)")
//
////                // is exist
////                let path = docu + prog.objectId
////                if FileManager.default.fileExists(atPath: path) {
////                    existObjectIds.append(prog.objectId)
////                    SDKDebugLog("IMBigFileDownloadChannel wait progress data is exist! objectId: \(prog.objectId)")
////                    continue
////                }
//
//                let objectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
////                let path1 = docu + objectId
////                if FileManager.default.fileExists(atPath: path1) {
////                    existObjectIds.append(objectId)
////                    SDKDebugLog("IMBigFileDownloadChannel wait progress data is exist! objectId: \(objectId)")
////                    continue
////                }
////
////                // error bucketid frome Android upload
////                if prog.bucketId == UploadLogRecordFileBucketId {
////                    SDKDebugLog("IMBigFileDownloadChannel wait progress is error bucketID: \(prog.bucketId), objectId: \(objectId)")
////                    continue
////                }
//
////                // is staring...
////                if self.channelMaybeContain(objectId: objectId) {
////                    SDKDebugLog("IMBigFileDownloadChannel wait progress is starting - 1, objectId: \(objectId)")
////                    continue
////                }
//
//                if tOss.networkMaybeMatch(progressModel: prog) == false {
//                    SDKDebugLog("IMBigFileDownloadChannel network not match, objectId: \(objectId)")
//                    continue
//                }
//
//                let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.small
//                if tOss.waitDownloadMaybeExpire(progressModel: prog) == true {
//                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType, isNeedNotice: prog.isNeedNotice)
//                    status.overTime(objectId: objectId)
//                    SDKDebugLog("IMBigFileDownloadChannel time expire 3 days, objectId: \(objectId)")
//                    continue
//                }
//
//                let promise = IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: tOss).then { downloader -> Promise<Void> in
//
////                    sourceSenceMap[objectId] = prog.sourceSence
//
//                    var tempDownloader: IMDownloader = downloader
//                    tempDownloader.ossPath = tOss.ossPath
//                    tempDownloader.ossContext = tOss.ossContext
//
//
//                    // add into cache map
//                    let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
//                    self.downloaders.append(downloadingModel)
//                    SDKDebugLog("IMBigFileDownloadChannel download add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
//
//
////                    if let loader = tempDownloader as? IMThumDownLoader,
////                       let sourceSence = sourceSenceMap[objectId],
////                       let sence: IMTransferSence = IMTransferSence(rawValue: sourceSence) {
////                        loader.sourceSence = sence
////                    }
//
//                    // start task
//                    tempDownloader.download(objectID: objectId)
//                    SDKDebugLog("IMBigFileDownloadChannel download start downloading: \(objectId)!")
//
//
//
//                    // send event
//                    let startValue: Int = IMTransferProgressState.start.rawValue
//                    return IMFileProgressDao(db: dataBase).updateProgressStart(objectIds: [objectId], progress: startValue).then { _ -> Promise<Void> in
//
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: tOss.ossContext.nc)
//
//                        let fileDownloadEvent = IMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [objectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        return Promise<Void>.resolve()
//                    }
//                    /*
//                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType, isNeedNotice: prog.isNeedNotice)
//                    return status.startDownload(objectId: objectId).then { resuleStatus -> Promise<Void> in
//                        return Promise<Void>.resolve()
//                    }*/
//                }
//
//                promiseArr.append(promise)
//            }
//
//            if existObjectIds.count > 0 {
//
//                let notificationManager: IMNotificationManager = IMNotificationManager(notific: tOss.ossContext.nc)
//
//                let fileDownloadEvent = IMFileDownloadEvent()
//                fileDownloadEvent.objectIds = existObjectIds
//                notificationManager.post(eventProtocol: fileDownloadEvent)
//
//            }
//
//            if promiseArr.count != 0 {
//
//                return Promise.all(promiseArr).then { _ -> Promise<Void> in
//
//                    self.isNextWork = false
//                    return Promise<Void>.resolve()
//                }.catch { error in
//                    self.isNextWork = false
//                    return Promise.reject(error)
//                }
//
//            }else {
//                self.isNextWork = false
//                return Promise<Void>.resolve()
//            }
//
//        }
//
//    }
    
    override func next() {
        
        if self.grabWork.isGarbing() == true {
            SDKDebugLog("[\(self)] [\(#function)] grab is working!")
            return
        }
        
        guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
            dbErrorLog("[\(self)] [\(#function)] context db is nil")
            return
        }
        
        if self.currentNextPromise != nil {
            SDKDebugLog("[\(self)] [\(#function)] next is working!")
            return
        }
        
        let tPromise = self.startNext(tOss: tOss, dataBase: dataBase)
        tPromise.then { _ -> Promise<Void> in
            
            self.currentNextPromise = nil
            return Promise<Void>.resolve()
        }.catch { error in
            
            self.currentNextPromise = nil
            return Promise.reject(error)
        }
        self.currentNextPromise = tPromise
    }
    
    private func startNext(tOss: IMOSS, dataBase: Database) -> Promise<Void> {
        
        let max: Int = getTaskAsyncMaxCount()
        let freeCount: Int = max - downloaders.count
        if freeCount <= 0 {
            SDKDebugLog("[\(self)] [\(#function)] no free downloader! current map keys: \(self.downloadingObjectIds())")
            return  Promise<Void>.resolve()
        }
        return IMFileProgressDao(db: dataBase).queryBigFileWaitProgress(count: freeCount).then { waitProgress -> Promise<Void> in
            
            if waitProgress.isEmpty {
                SDKDebugLog("[\(self)] [\(#function)] no wait progress!")
                return Promise<Void>.resolve()
            }
            
            var promiseArr: [Promise<Void>] = []
            for prog in waitProgress {
                
                SDKDebugLog("[\(self)] [\(#function)] wait progress objectId: \(prog.objectId), status: \(prog.progress)")
                if self.fileMaybeExist(prog: prog) { continue }
                
                let objectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
                
                // error bucketid frome Android upload
                if prog.bucketId == UploadLogRecordFileBucketId {
                    SDKDebugLog("[\(self)] [\(#function)] wait progress is error bucketID: \(prog.bucketId), objectId: \(objectId)")
                    continue
                }
                
                if self.grabWork.isSame(objectId: prog.objectId) == true {
                    continue
                }
                
                let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.small
                if self.grabWork.isGarbing() == true {
                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
                    status.channelGrabbed(objectId: objectId)
                    continue
                }
                
                if tOss.networkMaybeMatch(progressModel: prog) == false {
                    SDKDebugLog("[\(self)] [\(#function)] network not match, objectId: \(objectId)")
                    continue
                }

                if tOss.waitDownloadMaybeExpire(progressModel: prog) == true {
                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType, isNeedNotice: prog.isNeedNotice)
                    status.overTime(objectId: objectId)
                    SDKDebugLog("[\(self)] [\(#function)] time expire 3 days, objectId: \(objectId)")
                    continue
                }
                
                let promise = IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: tOss).then { downloader -> Promise<Void> in
                    
                    if self.fileMaybeExist(prog: prog) {
                        return Promise<Void>.resolve()
                    }
                    if self.grabWork.isSame(objectId: prog.objectId) == true {
                        return Promise<Void>.resolve()
                    }
                    
                    let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.small
                    if self.grabWork.isGarbing() == true {
                        let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
                        status.channelGrabbed(objectId: objectId)
                        return Promise<Void>.resolve()
                    }
                    
                    
                    var tempDownloader: IMDownloader = downloader
                    if let loader = downloader as? IMThumDownLoader,
                       let sence: IMTransferSence = IMTransferSence(rawValue: prog.sourceSence) {
                        loader.sourceSence = sence
                        tempDownloader = loader
                    }
                    tempDownloader.ossPath = tOss.ossPath
                    tempDownloader.ossContext = tOss.ossContext
                    
                    // add into cache arr
                    let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
                    self.downloaders.append(downloadingModel)
                    SDKDebugLog("[\(self)] [\(#function)] downloader add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                    
                    // start task
                    tempDownloader.download(objectID: objectId)
                    SDKDebugLog("\(self)] [\(#function)] download start downloading: \(objectId)!")
                    
                    return Promise<Void>.resolve()
                }.catch { error in
                    
                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
                    status.failed(objectId: prog.objectId)
                    return Promise.reject(error)
                }
                
                promiseArr.append(promise)
            }
            
            if promiseArr.count != 0 {
                return Promise.all(promiseArr).then { _ -> Promise<Void> in
                    return Promise<Void>.resolve()
                }
            }
            return Promise<Void>.resolve()
        }
    }
    
//    override func channelMaybeIdle() -> Promise<Bool> {
//        if self.currentNextPromise != nil {
//            return self.currentNextPromise!.then { _ -> Promise<Bool> in
//                if self.grabWork.isGarbing() {
//                    return Promise<Bool>.resolve(false)
//                }
//                return Promise<Bool>.resolve(true)
//            }.catch { error in
//                if self.grabWork.isGarbing() {
//                    return Promise<Bool>.resolve(false)
//                }
//                return Promise<Bool>.resolve(true)
//            }
//        }
//        if self.grabWork.isGarbing() {
//            return Promise<Bool>.resolve(false)
//        }
//        return Promise<Bool>.resolve(true)
//    }
    
//    override func removeChannel(objectId: String) {
//        if let _ = self.downloaderMap[objectId] {
//            self.downloaderMap.removeValue(forKey: objectId)
//        }
//    }
    
    override func channelMaybeIdle() -> Bool {
//        if self.isNextWork == true {
//            return self.channelMaybeIdle()
//        }
//        if self.grabWork.isGarbing() == true {
//            return self.channelMaybeIdle()
//        }
        if self.currentNextPromise != nil || self.grabWork.isGarbing() {
            return false
        }
        let channelIsEmpty = downloaders.count < getTaskAsyncMaxCount()
        if channelIsEmpty {
            return true
        }
        return false
    }
    
    private func getTaskAsyncMaxCount() -> Int {
        return 1
    }
    
    override func channelMaybeContainSmallFile() -> Bool {
        return false
    }
    /*
    override func into(objectId: String) {
        
//        if self.downloaderMap.keys.contains(objectId), let downloader = self.downloaderMap[objectId] {
//            SDKDebugLog("[\(#function)] IMSmallFileDownloadChannel wait progress is starting - 1, objectId: \(objectId)")
//            downloader.increaseReferenceCount()
//            return
//        }
        
        self.isGrabWork = true
        guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
            self.isGrabWork = false
            dbErrorLog("IMBigFileDownloadChannel [\(#function)] context db is nil")
            return
        }
        
        IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId).then { tProg -> Promise<Void> in
            
            guard let prog = tProg else {
                self.isGrabWork = false
                return Promise.reject(IMNetworkingError.createCommonError())
            }
            
            SDKDebugLog("IMBigFileDownloadChannel into objectId: \(prog.objectId), status: \(prog.progress)")
            let objectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
            
            return IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: self.oss).then { downloader -> Promise<Void> in
                
                var tempDownloader: IMDownloader = downloader
                tempDownloader.ossPath = tOss.ossPath
                tempDownloader.ossContext = tOss.ossContext
                
                
                // add into cache map
                let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
                self.downloaders.append(downloadingModel)
                SDKDebugLog("IMBigFileDownloadChannel intodownload add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                
//                if let loader = tempDownloader as? IMThumDownLoader,
//                   let sence: IMTransferSence = IMTransferSence(rawValue: prog.sourceSence) {
//                    loader.sourceSence = sence
//                }
                
                // start task
                tempDownloader.download(objectID: objectId)
                SDKDebugLog("IMBigFileDownloadChannel intodownload start downloading: \(objectId)!")
                
                self.isGrabWork = false
                return Promise<Void>.resolve()
            }.catch { error in
                self.isGrabWork = false
                return Promise.reject(error)
            }
            
        }
        
    }*/
    
    override func cancelDownloadingBigFileOnNetChange() {
        
        if self.currentNextPromise != nil {
            self.currentNextPromise!.then { _ -> Promise<Void> in
                self.startCanleDownloadingBigFile()
                return Promise<Void>.resolve()
            }.catch { error in
                self.startCanleDownloadingBigFile()
                return Promise<Void>.reject(error)
            }
           return
        }
        
        if self.grabWork.isGarbing() {
            Promise.all(self.grabWork.getAllPromise()).then { _ -> Promise<Void> in
                self.startCanleDownloadingBigFile()
                return Promise<Void>.resolve()
            }.catch { error in
                self.startCanleDownloadingBigFile()
                return Promise<Void>.reject(error)
            }
            return
        }
        self.startCanleDownloadingBigFile()
    }
}




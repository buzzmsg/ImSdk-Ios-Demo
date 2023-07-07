//
//  IMShareDownloadChannel.swift
//  CommonModule
//
//  Created by Joey on 2023/5/15.
//

import Foundation
import WCDBSwift


class IMShareDownloadChannel: IMBaseDownloadChannel {
    
    override init() {
        super.init()
        self.grabWork.allowMultiple = true
    }
    
//    override func next() -> Promise<Void> {
//        
//        if self.grabWork.isGarbing() == true {
//            SDKDebugLog("IMSmallFileDownloadChannel grabNext is working!")
//            return Promise<Void>.reject(IMNetworkingError.createCommonError())
//        }
//        
//        if self.isNextWork == true {
//            SDKDebugLog("IMShareDownloadChannel is working!")
//            return Promise<Void>.reject(IMNetworkingError.createCommonError())
//        }
//        self.isNextWork = true
//       
//        guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
//            self.isNextWork = false
//            dbErrorLog("IMShareDownloadChannel [\(#function)] context db is nil")
//            return Promise<Void>.reject(IMNetworkingError.createCommonError())
//        }
//                
//        let max: Int = getTaskAsyncMaxCount()
//        let freeCount: Int = max - downloaders.count
//        if freeCount <= 0 {
//            self.isNextWork = false
//            SDKDebugLog("IMShareDownloadChannel no free downloader! current map keys: \(self.downloadingObjectIds())")
//            return Promise<Void>.resolve()
//        }
//        
//        if freeCount == 1, self.grabWork.isGarbing()  {
//            self.isNextWork = false
//            SDKDebugLog("IMShareDownloadChannel no free downloader! current map keys: \(self.downloadingObjectIds())， grab is work!")
//            return Promise<Void>.reject(IMNetworkingError.createCommonError())
//        }
//        
//        return IMFileProgressDao(db: dataBase).queryBigFilePriorityWaitProgress(count: freeCount).then { waitProgress -> Promise<Void> in
//            
//            if waitProgress.isEmpty {
//                self.isNextWork = false
//                SDKDebugLog("IMShareDownloadChannel no wait progress!")
//                return Promise<Void>.resolve()
//            }
//            
//            var existObjectIds: [String] = []
////            let docu: String = tOss.ossPath
//            
//            var promiseArr: [Promise<Void>] = []
//            var sourceSenceMap: [String: Int] = [:]
//            for prog in waitProgress {
//                
//                SDKDebugLog("IMShareDownloadChannel wait progress next objectId: \(prog.objectId), status: \(prog.progress)")
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
////                    SDKDebugLog("IMShareDownloadChannel wait progress is starting - 1, objectId: \(objectId)")
////                    continue
////                }
//                
//                let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.small
//                if prog.sizeType == IMTransferFileSizeType.big.rawValue {
//
//                    if tOss.networkMaybeMatch(progressModel: prog) == false {
//                        SDKDebugLog("IMShareDownloadChannel network not match, objectId: \(objectId)")
//                        continue
//                    }
//
//                    if tOss.waitDownloadMaybeExpire(progressModel: prog) == true {
//                        let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType, isNeedNotice: prog.isNeedNotice)
//                        status.overTime(objectId: objectId)
//                        SDKDebugLog("IMShareDownloadChannel time expire 3 days, objectId: \(objectId)")
//                        continue
//                    }
//
//                }
//                
//                let promise = IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: tOss).then { downloader -> Promise<Void> in
//                    
//                    sourceSenceMap[objectId] = prog.sourceSence
//                    
//                    var tempDownloader: IMDownloader = downloader
//                    tempDownloader.ossPath = tOss.ossPath
//                    tempDownloader.ossContext = tOss.ossContext
//                    
//                    
//                    // add into cache map
//                    let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
//                    self.downloaders.append(downloadingModel)
//                    SDKDebugLog("IMShareDownloadChannel download add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
//                    
//                    
//                    if let loader = tempDownloader as? IMThumDownLoader,
//                       let sourceSence = sourceSenceMap[objectId],
//                       let sence: IMTransferSence = IMTransferSence(rawValue: sourceSence) {
//                        loader.sourceSence = sence
//                    }
//                    
//                    // start task
//                    tempDownloader.download(objectID: objectId)
//                    SDKDebugLog("IMShareDownloadChannel download start downloading: \(objectId)!")
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
    
    private func isFull() -> Bool {
        let max: Int = getTaskAsyncMaxCount()
        return (self.grabWork.currentGrabingCount() + self.downloaders.count >= max)
    }
    
    private func startNext(tOss: IMOSS, dataBase: Database) -> Promise<Void> {
        
        let max: Int = getTaskAsyncMaxCount()
        var freeCount: Int = max - downloaders.count
        if freeCount <= 0 {
            SDKDebugLog("[\(self)] [\(#function)] no free downloader! current map keys: \(self.downloadingObjectIds())")
            return  Promise<Void>.resolve()
        }
        if self.grabWork.isGarbing() {
            freeCount = freeCount - self.grabWork.currentGrabingCount()
        }
        if freeCount <= 0 {
            SDKDebugLog("[\(self)] [\(#function)] no free downloader! because grab is working! grab objectIds: \(self.grabWork.getCurrentGarbObjectIds()) current map keys: \(self.downloadingObjectIds())")
            return Promise<Void>.resolve()
        }
        
        return IMFileProgressDao(db: dataBase).queryBigFilePriorityWaitProgress(count: freeCount).then { waitProgress -> Promise<Void> in
            
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
                if self.isFull() {
                    let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
                    status.channelGrabbed(objectId: objectId)
                    continue
                }
                
                if prog.sizeType == IMTransferFileSizeType.big.rawValue {
                    
                    if tOss.networkMaybeMatch(progressModel: prog) == false {
                        SDKDebugLog("\(self)] [\(#function)] network not match, objectId: \(objectId)")
                        continue
                    }
                    
                    if tOss.waitDownloadMaybeExpire(progressModel: prog) == true {
                        let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType, isNeedNotice: prog.isNeedNotice)
                        status.overTime(objectId: objectId)
                        SDKDebugLog("\(self)] [\(#function)] time expire 3 days, objectId: \(objectId)")
                        continue
                    }
                    
                }
                
                let promise = IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: tOss).then { downloader -> Promise<Void> in
                    
                    if self.fileMaybeExist(prog: prog) {
                        return Promise<Void>.resolve()
                    }
                    if self.grabWork.isSame(objectId: prog.objectId) == true {
                        return Promise<Void>.resolve()
                    }
                    if self.isFull() {
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
    
    override func channelMaybeIdle() -> Bool {
        if self.currentNextPromise != nil {
            return false
        }
        var freeCount: Int = getTaskAsyncMaxCount() - downloaders.count
        if self.grabWork.isGarbing() {
            freeCount = freeCount - self.grabWork.currentGrabingCount()
        }
        let channelHaveFree = freeCount != 0
        if channelHaveFree {
            return true
        }
        return false
    }
    
    private func getTaskAsyncMaxCount() -> Int {
        return 3
    }
    
    override func channelMaybeContainSmallFile() -> Bool {
        var maybe: Bool = false
        for downloadingModel in self.downloaders {
            if downloadingModel.prog.sizeType == IMTransferFileSizeType.small.rawValue {
                maybe = true
                break
            }
        }
        return maybe
    }
    
    
    override func grab(prog: IMFileProgressModel) {
        
        guard let tOss = self.oss else {
            dbErrorLog("IMShareDownloadChannel [\(#function)] oss is nil")
            return
        }
        
        if var downloadingModel = self.downloaders.first {
            
            var removeIndex: Int = 0
            for (tIdx, tModel) in self.downloaders.enumerated() {
                if tModel.prog.sizeType == IMTransferFileSizeType.small.rawValue {
                    downloadingModel = tModel
                    removeIndex = tIdx
                    break
                }
            }
            
            self.downloaders.remove(at: removeIndex)
            let removeObjectId: String = downloadingModel.prog.objectId
            SDKDebugLog("\(self)] [\(#function)] start grab and remove channel, garbObjectId is : \(prog.objectId)， sizeType is: \(prog.sizeType), removeObjectId is \(removeObjectId)， sizeType is: \(downloadingModel.prog.sizeType)!")
            downloadingModel.downloader.cancel(objectId: removeObjectId) { }
            let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: downloadingModel.prog.sizeType) ?? IMTransferFileSizeType.small
            let status: OssDownLoadStatus = OssDownLoadFactory().create(status: downloadingModel.prog.progress, oss: tOss, bucketId: downloadingModel.prog.bucketId, sizeType: sizeType, isNeedNotice: downloadingModel.prog.isNeedNotice)
            status.channelGrabbed(objectId: removeObjectId)
            
        }else {
            
            let grabProgressArr = self.grabWork.getAllProgress()
            if var grabProg = grabProgressArr.first {
                
                for (_, tModel) in grabProgressArr.enumerated() {
                    if tModel.sizeType == IMTransferFileSizeType.small.rawValue {
                        grabProg = tModel
                        break
                    }
                }
                
                let removeObjectId: String = grabProg.objectId
                self.grabWork.deletGarb(objectId: removeObjectId)
                SDKDebugLog("\(self)] [\(#function)] start grab and remove grabing, garbObjectId is : \(prog.objectId)， sizeType is: \(prog.sizeType), removeObjectId is \(removeObjectId)， sizeType is: \(grabProg.sizeType)!")
                let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: grabProg.sizeType) ?? IMTransferFileSizeType.small
                let status: OssDownLoadStatus = OssDownLoadFactory().create(status: grabProg.progress, oss: tOss, bucketId: grabProg.bucketId, sizeType: sizeType, isNeedNotice: grabProg.isNeedNotice)
                status.channelGrabbed(objectId: removeObjectId)
            }
        }
        
        self.into(prog: prog)
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
            dbErrorLog("IMShareDownloadChannel [\(#function)] context db is nil")
            return
        }
        
        IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId).then { tProg -> Promise<Void> in
            
            guard let prog = tProg else {
                self.isGrabWork = false
                return Promise.reject(IMNetworkingError.createCommonError())
            }
            
            SDKDebugLog("IMShareDownloadChannel into objectId: \(prog.objectId), status: \(prog.progress)")
            let objectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
            
            return IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: self.oss).then { downloader -> Promise<Void> in
                
                var tempDownloader: IMDownloader = downloader
                tempDownloader.ossPath = tOss.ossPath
                tempDownloader.ossContext = tOss.ossContext
                
                
                // add into cache map
                let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
                self.downloaders.append(downloadingModel)
                SDKDebugLog("IMShareDownloadChannel intodownload add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                
                
                if let loader = tempDownloader as? IMThumDownLoader,
                   let sence: IMTransferSence = IMTransferSence(rawValue: prog.sourceSence) {
                    loader.sourceSence = sence
                }
                
                // start task
                tempDownloader.download(objectID: objectId)
                SDKDebugLog("IMShareDownloadChannel intodownload start downloading: \(objectId)!")
                
                self.isGrabWork = false
                return Promise<Void>.resolve()
            }.catch { error in
                self.isGrabWork = false
                return Promise.reject(error)
            }
            
        }
        
    }*/
    
    override func cancelDownloadingBigFileOnNetChange() {
        var promiseArr: [Promise<Void>] = []
        if let tPromise = self.currentNextPromise {
            promiseArr.append(tPromise)
        }
        if self.grabWork.isGarbing() {
            promiseArr.append(contentsOf: self.grabWork.getAllPromise())
        }
        
        if promiseArr.count == 0 {
            self.startCanleDownloadingBigFile()
            return
        }
        
        Promise.all(promiseArr).then { _ -> Promise<Void> in
            self.startCanleDownloadingBigFile()
            return Promise<Void>.resolve()
        }.catch { error in
            self.startCanleDownloadingBigFile()
            return Promise<Void>.reject(error)
        }
    }
    
}





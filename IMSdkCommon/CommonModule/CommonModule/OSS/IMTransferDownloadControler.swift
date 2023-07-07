//
//  IMTransferDownloadControler.swift
//  TMM
//
//  Created by  on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

public class IMTransferDownloadControler: NSObject {
    
    
    private var smallFileChannel: IMDownloadChannel
    private var bigFileChannel: IMDownloadChannel
    private var shareChannel: IMDownloadChannel
    weak var oss: IMOSS?
    
 
    public var downloaderMap: [String: IMDownloader] = [:]

    var ossContext: IMContext
    var ossPath: String
    private var deleagte: IMOSSDelegate?
    
    func setDelegate(del: IMOSSDelegate) {
        self.deleagte = del
    }
    func setOss(oss: IMOSS) {
        self.oss = oss
        
        self.smallFileChannel.setOss(oss: oss)
        self.bigFileChannel.setOss(oss: oss)
        self.shareChannel.setOss(oss: oss)
    }
    
    
    init(context: IMContext, ossPath: String) {
        self.ossContext = context
        self.ossPath = ossPath
        self.smallFileChannel = IMSmallFileDownloadChannel()
        self.bigFileChannel = IMBigFileDownloadChannel()
        self.shareChannel = IMShareDownloadChannel()
        super.init()

        let notificationManager: IMNotificationManager = IMNotificationManager(notific: context.nc)
        notificationManager.observer(self, IMFileDownloadEvent.init().getName()) {
            [weak self] (obj, dataValue) in
            guard let self = self else {
                return
            }
            
            let downEvent: IMFileDownloadEvent = dataValue as! IMFileDownloadEvent
            DispatchQueue.main.async {
                self.obeserDownloadEvent(downEvent: downEvent)
            }
        }
    }
    

    private func obeserDownloadEvent(downEvent: IMFileDownloadEvent) {
        
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
        let docu: String = self.ossPath
        
        /*
        var successIds: [String] = []
        var errorIds: [String] = []
        */
        
        SDKDebugLog("[\(self)][\(#function)] was excuted !! downEvent.objectIds is \(downEvent.objectIds)")
        downEvent.objectIds.forEach { objectID in
            let path = docu + objectID
            SDKDebugLog("11111 -> [\(self)][\(#function)] was excuted !! objectID is \(objectID), check path is \(path)")
            if FileManager.default.fileExists(atPath: path) {
                
                // cancel task
                /*if let downloader: IMDownloader = downloaderMap[objectID] {
                    downloader.cancel(objectId: objectID) {[weak self] in
                        guard let self = self else {
                            return
                        }
                        // clean cache Downloader
                        self.downloaderMap.removeValue(forKey: objectID)
                        SDKDebugLog("TMDownloading success -- objectID: \(objectID)")

                        successIds.append(objectID)
                        
                        _ = IMFileProgressDao(db: dataBase).removePregress(objectIds: successIds).then({ Void ->  Promise<Void> in
                            SDKDebugLog("TMDownloading success and continue download...")
                            self.downloading()
                            return Promise<Void>.resolve()
                        })
                    }
                }*/
                SDKDebugLog("22222 -> [\(self)][\(#function)] was excuted !! objectID is \(objectID), check path is \(path)")
                _ = IMFileProgressDao(db: dataBase).removePregress(objectIds: [objectID]).then({ Void ->  Promise<Void> in
                    SDKDebugLog("TMDownloading success and continue download... success objectId is \(objectID)")
                    self.smallFileChannel.success(objectIds: [objectID])
                    self.bigFileChannel.success(objectIds: [objectID])
                    self.shareChannel.success(objectIds: [objectID])
                    self.downloading()
                    return Promise<Void>.resolve()
                })
                
                
            } else {
                
                let value: Int = IMFileProgressDao(db: dataBase).queryProgressValueWithEvent(objectId: objectID)
                /*if value == IMTransferProgressState.fileNotExist.rawValue ||
                    value < IMTransferProgressState.start.rawValue {
                    
                    // cancel task
                    if let downloader: IMDownloader = downloaderMap[objectID] {
                        downloader.cancel(objectId: objectID) {[weak self] in
                            guard let self = self else {
                                return
                            }
                            // clean cache Downloader
                            self.downloaderMap.removeValue(forKey: objectID)
                            SDKDebugLog("TMDownloading error -- objectID: \(objectID)")

                            errorIds.append(objectID)
                            
                            _ = IMFileProgressDao(db: dataBase).removePregress(objectIds: successIds).then({ Void ->  Promise<Void> in
                                SDKDebugLog("TMDownloading success and continue download...")
                                self.smallFileChannel.removeChannel(objectId: objectID)
                                self.bigFileChannel.removeChannel(objectId: objectID)
                                self.shareChannel.removeChannel(objectId: objectID)
                                self.downloading()
                                return Promise<Void>.resolve()
                            })
                            
                        }
                    }
                    
                }*/
                let status = IMConfigManager.default.getOssStaus(progress: value)
                if status == OssDownLoadStatusConstant.fail.rawValue {
                    SDKDebugLog("TMDownloading falied and continue download... falied objectId is \(objectID)")
                    self.smallFileChannel.cancel(objectIds: [objectID])
                    self.bigFileChannel.cancel(objectIds: [objectID])
                    self.shareChannel.cancel(objectIds: [objectID])
                    self.downloading()
                    return
                }
                if status == OssDownLoadStatusConstant.wait.rawValue {
                    SDKDebugLog("TMDownloading wait and continue download... wait objectId is \(objectID)")
                    self.smallFileChannel.wait(objectIds: [objectID])
                    self.bigFileChannel.wait(objectIds: [objectID])
                    self.shareChannel.wait(objectIds: [objectID])
                    self.downloading()
                    return
                }
            }
        }
    }
    

    
    public func reTryDownloadOSS() {
        downloaderMap.removeAll()
        downloading()
    }

    func grabDownloading(objectId: String) {
        
        guard let dataBase = oss?.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
//        let queryPromise = IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId)
//        let bigPromise = self.bigFileChannel.channelMaybeIdle()
//        let smallPromise = self.smallFileChannel.channelMaybeIdle()
//        let sharePromise = self.shareChannel.channelMaybeIdle()
//        Promise.all(queryPromise, bigPromise, smallPromise, sharePromise).then { <#(IMFileProgressModel?, Bool, Bool, Bool)#> in
//            <#code#>
//        }
        IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId).then { progressModel -> Promise<Void> in
            
            if let tModel = progressModel {
                if tModel.sizeType == IMTransferFileSizeType.big.rawValue {
                    
                    if self.bigFileChannel.channelMaybeIdle() == true {
                        self.bigFileChannel.into(prog: tModel)
                        return Promise<Void>.resolve()
                    }
                    if self.shareChannel.channelMaybeIdle() == true {
                        self.shareChannel.into(prog: tModel)
                        return Promise<Void>.resolve()
                    }
                    self.shareChannel.grab(prog: tModel)
                    return Promise<Void>.resolve()
                }

                if tModel.sizeType == IMTransferFileSizeType.small.rawValue {
                    
                    if self.smallFileChannel.channelMaybeIdle() {
                        self.smallFileChannel.into(prog: tModel)
                        return Promise<Void>.resolve()
                    }
                    
                    if self.shareChannel.channelMaybeIdle() {
                        self.shareChannel.into(prog: tModel)
                        return Promise<Void>.resolve()
                    }
                    
                    if self.shareChannel.channelMaybeContainSmallFile() {
                        self.shareChannel.grab(prog: tModel)
                        return Promise<Void>.resolve()
                    }
                    
                    self.smallFileChannel.grab(prog: tModel)
                    return Promise<Void>.resolve()
                }
            }
            return Promise<Void>.resolve()
        }
        
    }
    
    func cancelDownload(objectIds: [String]) {
        self.smallFileChannel.cancel(objectIds: objectIds)
        self.bigFileChannel.cancel(objectIds: objectIds)
        self.shareChannel.cancel(objectIds: objectIds)
    }
    
    func pauseDownload(objectId: String) {
        self.smallFileChannel.pause(objectId: objectId)
        self.bigFileChannel.pause(objectId: objectId)
        self.shareChannel.pause(objectId: objectId)
    }
    
    func maybeDownloading(objectId: String) -> Bool {
        return (self.smallFileChannel.channelMaybeContain(objectId: objectId) ||
                self.bigFileChannel.channelMaybeContain(objectId: objectId) ||
                self.shareChannel.channelMaybeContain(objectId: objectId))
    }
    
    func networkChange() {
        self.bigFileChannel.cancelDownloadingBigFileOnNetChange()
        self.shareChannel.cancelDownloadingBigFileOnNetChange()
    }
    
    func clearAllChannel() {
        self.smallFileChannel.clearAllChannel()
        self.shareChannel.clearAllChannel()
        self.bigFileChannel.clearAllChannel()
    }
    
    func downloading() {
        
        self.smallFileChannel.next()
        self.bigFileChannel.next()
        self.shareChannel.next()
        
        return
        
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
        SDKDebugLog("TMDownloading current map keys: \(downloaderMap.keys)")

        let max: Int = getTaskAsyncMaxCount()
        let freeCount: Int = max - downloaderMap.count
        if freeCount <= 0 {
            SDKDebugLog("TMDownloading no free downloader!")
            return
        }
        
        IMFileProgressDao(db: dataBase).getWaitProgress(count: freeCount).then { waitProgress -> Promise<Void> in
         
            if waitProgress.isEmpty {
                SDKDebugLog("TMDownloading no wait progress!")
                return Promise<Void>.resolve()
            }
            
            
            var existObjectIds: [String] = []
            let docu: String = self.ossPath
                        
//            var promiseArr: [Promise<IMDownloader>] = []
//            var newDownloaderObjectIds: [String] = []
            var sourceSenceMap: [String: Int] = [:]
            for prog in waitProgress {
                
                SDKDebugLog("TMDownloading wait progress next objectId: \(prog.objectId), status: \(prog.progress)")
                
                // is exist
                let path = docu + prog.objectId
                if FileManager.default.fileExists(atPath: path) {
                    existObjectIds.append(prog.objectId)
                    SDKDebugLog("TMDownloading wait progress data is exist! objectId: \(prog.objectId)")
                    continue
                }
                
                let objectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
                let path1 = docu + objectId
                if FileManager.default.fileExists(atPath: path1) {
                    existObjectIds.append(objectId)
                    SDKDebugLog("TMDownloading wait progress data is exist! objectId: \(objectId)")
                    continue
                }
                
                // error bucketid frome Android upload
                if prog.bucketId == UploadLogRecordFileBucketId {
                    SDKDebugLog("TMDownloading wait progress is error bucketID: \(prog.bucketId), objectId: \(objectId)")
                    continue
                }
                
                // is staring...
                if self.downloaderMap.keys.contains(objectId) {
                    SDKDebugLog("TMDownloading wait progress is starting - 1, objectId: \(objectId)")
                    continue
                }
                
                IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: self.ossContext, objectID: objectId, isNeedNotice: prog.isNeedNotice, deleagte: self.deleagte, oss: self.oss!).then { downloader -> Promise<Void> in
                    
                    sourceSenceMap[objectId] = prog.sourceSence

                    // is staring...
                    if self.downloaderMap.keys.contains(objectId) {
                        SDKDebugLog("TMDownloading wait progress is starting - 2, objectId: \(objectId)")
                        return Promise<Void>.resolve()
                    }
                    
                    if self.downloaderMap.count >= max {
                        SDKDebugLog("TMDownloading download map is full!!! objectId: \(objectId)")
                        return Promise<Void>.resolve()
                    }
                    
        
                    // is exist
                    let path = docu + objectId
                    if FileManager.default.fileExists(atPath: path) {
                        existObjectIds.append(objectId)
                        SDKDebugLog("TMDownloading wait progress data is exist! - 2 objectId: \(objectId)")
                        return Promise<Void>.resolve()
                    }
                    
                    var tempDownloader: IMDownloader = downloader
                    tempDownloader.ossPath = self.ossPath
                    tempDownloader.ossContext = self.ossContext
                    
                    
                    // add into cache map
                    self.downloaderMap[objectId] = tempDownloader
                    SDKDebugLog("TMDownloading download add new! objectId: \(objectId), downloaderMap keys: \(self.downloaderMap.keys)!")
                    
                    
                    if let loader = tempDownloader as? IMThumDownLoader,
                       let sourceSence = sourceSenceMap[objectId],
                       let sence: IMTransferSence = IMTransferSence(rawValue: sourceSence) {
                        loader.sourceSence = sence
                    }
                    
                    // start task
                    tempDownloader.download(objectID: objectId)
                    SDKDebugLog("TMDownloading download start downloading: \(objectId)!")
                    

                    // send event
                    let startValue: Int = IMTransferProgressState.start.rawValue
                    return IMFileProgressDao(db: dataBase).updateProgressStart(objectIds: [objectId], progress: startValue).then { _ -> Promise<Void> in
                        
                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.ossContext.nc)
                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectId)")
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [objectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        
                        return Promise<Void>.resolve()
                    }

                }
                
//                promiseArr.append(promise)
                
//                newDownloaderObjectIds.append(objectId)
            }
            
            if existObjectIds.count > 0 {
                
                let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.ossContext.nc)
                SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(existObjectIds)")
                let fileDownloadEvent = IMFileDownloadEvent()
                fileDownloadEvent.objectIds = existObjectIds
                notificationManager.post(eventProtocol: fileDownloadEvent)
                
            }
//            Promise.all(promiseArr).then { downloaderArr -> Promise<Void> in
//
//
//                var objectIdArr: [String] = []
//                for (idx, downloader) in downloaderArr.enumerated() {
//
//                    let objectId = newDownloaderObjectIds[idx]
//
//                    // is staring...
//                    if self.downloaderMap.keys.contains(objectId) {
//                        SDKDebugLog("TMDownloading wait progress is starting - 2, objectId: \(objectId)")
//                        continue
//                    }
//
//                    if self.downloaderMap.count >= max {
//                        SDKDebugLog("TMDownloading download map is full!!! objectId: \(objectId)")
//                        continue
//                    }
//
//
//                    // is exist
//                    let path = docu + objectId
//                    if FileManager.default.fileExists(atPath: path) {
//                        existObjectIds.append(objectId)
//                        SDKDebugLog("TMDownloading wait progress data is exist! - 2 objectId: \(objectId)")
//                        return Promise<Void>.resolve()
//                    }
//
//                    var tempDownloader: IMDownloader = downloader
//                    tempDownloader.ossPath = self.ossPath
//                    tempDownloader.ossContext = self.ossContext
//
//
//                    // add into cache map
//                    self.downloaderMap[objectId] = tempDownloader
//                    SDKDebugLog("TMDownloading download add new! objectId: \(objectId), downloaderMap keys: \(self.downloaderMap.keys)!")
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
//                    SDKDebugLog("TMDownloading download start downloading: \(objectId)!")
//
//                    objectIdArr.append(objectId)
//
//                }
//
//
//                // send event
//                let startValue: Int = IMTransferProgressState.start.rawValue
//                return IMFileProgressDao(db: dataBase).updateProgressStart(objectIds: objectIdArr, progress: startValue).then { _ -> Promise<Void> in
//
//                    let notificationManager: IMNotificationManager = IMNotificationManager(notific: self.ossContext.nc)
//
//                    let fileDownloadEvent = IMFileDownloadEvent()
//                    fileDownloadEvent.objectIds = objectIdArr
//                    notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                    return Promise<Void>.resolve()
//                }
//            }

            return Promise<Void>.resolve()
        }
    }
    
    // MARK: -

    private func getTaskAsyncMaxCount() -> Int {
        return 50
    }
    
    private func releaseTaskAsyncMaxCount(){
       
    }
}

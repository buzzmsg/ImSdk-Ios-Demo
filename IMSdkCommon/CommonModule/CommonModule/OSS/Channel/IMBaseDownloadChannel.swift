//
//  IMBaseDownloadChannel.swift
//  CommonModule
//
//  Created by Joey on 2023/5/22.
//

import Foundation
import WCDBSwift


class IMDownloadingModel: NSObject {
    var downloader: IMDownloader
    var prog: IMFileProgressModel
    init(downloader: IMDownloader, prog: IMFileProgressModel) {
        self.downloader = downloader
        var tProg = prog
        if IMConfigManager.default.getOssStaus(progress: prog.progress) != OssDownLoadStatusConstant.progress.rawValue {
            tProg.progress = IMTransferProgressState.start.rawValue
        }
        self.prog = tProg
    }
}

class IMGrabTaskModel: NSObject {
    var prog: IMFileProgressModel
    var count: Int
    init(prog: IMFileProgressModel, count: Int) {
        self.prog = prog
        self.count = count
    }
}

class IMGrabWorkModel: NSObject {
    
    var allowMultiple: Bool = false
    //private var progressArr: [IMFileProgressModel] = []
    private var progressArr: [IMGrabTaskModel] = []
    private var promiseMap: [String : Promise<Void>] = [:]
    
    func setGrabObjectId(prog: IMFileProgressModel, promise: Promise<Void>) {
        if allowMultiple {
            self.promiseMap[prog.objectId] = promise
            let tModel: IMGrabTaskModel = IMGrabTaskModel(prog: prog, count: kDefaultReferenceCount)
            progressArr.append(tModel)
            return
        }
        
        if progressArr.count == 0 {
            progressArr.removeAll()
            promiseMap.removeAll()
        }
        self.promiseMap[prog.objectId] = promise
        let tModel: IMGrabTaskModel = IMGrabTaskModel(prog: prog, count: 1)
        progressArr.append(tModel)
    }
    func isSame(objectId: String) -> Bool {
        if allowMultiple {
            let objectIds: [String] = progressArr.map({$0.prog.objectId})
            return objectIds.contains(objectId)
        }
        
        if let progress = progressArr.first {
            return progress.prog.objectId == objectId
        }
        return false
    }
    
    //use for multiple
    func deletGarb(objectId: String) {
        if progressArr.count == 0 { return }
        progressArr.removeAll(where: {$0.prog.objectId == objectId})
        promiseMap.removeValue(forKey: objectId)
    }
    
    func getProgress(index: Int) -> IMFileProgressModel? {
        
        if allowMultiple {
            if index >= self.progressArr.count {
                return nil
            }
            return self.progressArr[index].prog
        }
        return self.progressArr.first?.prog
    }
    
    // user for single
    func deleteAll() {
        if progressArr.count == 0 { return }
        progressArr.removeAll()
        promiseMap.removeAll()
    }
    
    func isGarbing() -> Bool {
        return progressArr.count != 0
    }
    
    func currentGrabingCount() -> Int {
        if allowMultiple {
            return progressArr.count
        }
        return 1
    }
    
    func getAllProgress() -> [IMFileProgressModel] {
        return progressArr.map({$0.prog})
    }
    
    func getCurrentGarbObjectIds() -> [String] {
        let objectIds: [String] = progressArr.map({$0.prog.objectId})
        return objectIds
    }
    
    func getPromise(objectId: String) -> Promise<Void>? {
        return promiseMap[objectId]
    }
    
    func getAllPromise() -> [Promise<Void>] {
        return Array(promiseMap.values)
    }
    
    func increaseGrabTimeCount(objectId: String) {
        if let tModel = progressArr.first(where: {$0.prog.objectId == objectId}), let index = progressArr.firstIndex(where: {$0.prog.objectId == objectId}) {
            let count = tModel.count + 1
            tModel.count = count
            progressArr.replaceSubrange(index..<(index+1), with: [tModel])
        }
    }
    
    func getGrabTimeCount(objectId: String) -> Int {
        if let tModel = progressArr.first(where: {$0.prog.objectId == objectId}) {
            return tModel.count
        }
        return 1
    }
    
}

class IMBaseDownloadChannel: IMDownloadChannel {
    
    weak var oss: IMOSS?
    var downloaders: [IMDownloadingModel]
    var currentNextPromise: Promise<Void>?
    var grabWork: IMGrabWorkModel = IMGrabWorkModel()
    init() {
        self.downloaders = []
    }
    
    func cancel(objectIds: [String]) {
        let removeObjectIds: [String] = self.removeReferenceCount(objectIds: objectIds)
        if removeObjectIds.count == 0 { return }
        guard let tOss = oss, let dataBase = tOss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
        IMFileProgressDao(db: dataBase).queryProgressTimeAscendingOrder(objectIds: removeObjectIds).then { tModelArr -> Promise<Void> in
            
            tModelArr.forEach { modelProg in
                let st = OssDownLoadFactory().create(status: modelProg.progress, oss: tOss, bucketId: modelProg.bucketId, sizeType: IMTransferFileSizeType(rawValue: modelProg.sizeType)!)
                st.delete(objectId: modelProg.objectId)
            }
            return Promise<Void>.resolve()
        }
    }
    
    func pause(objectId: String) {
        
        guard let tOss = oss, let dataBase = tOss.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }
        
        IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectId).then { tProg -> Promise<Void> in
            
            if let prog = tProg, IMConfigManager.default.getOssStaus(progress: prog.progress) == OssDownLoadStatusConstant.wait.rawValue {
                let p = IMConfigManager.default.getOssProgress(progress: prog.progress)
                let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.pause.rawValue)
                return IMFileProgressDao(db: dataBase).updateProgress(objectId: objectId, progress: lp)
            }
            
            let removeObjectIds: [String] = self.removeReferenceCount(objectIds: [objectId])
            if removeObjectIds.count == 0 { return Promise<Void>.resolve() }
            return IMFileProgressDao(db: dataBase).queryProgressTimeAscendingOrder(objectIds: removeObjectIds).then { tModelArr -> Promise<Void> in
                
                tModelArr.forEach { modelProg in
                    let st = OssDownLoadFactory().create(status: modelProg.progress, oss: tOss, bucketId: modelProg.bucketId, sizeType: IMTransferFileSizeType(rawValue: modelProg.sizeType)!)
                    st.pause(objectId: modelProg.objectId)
                }
                return Promise<Void>.resolve()
            }
        }
    }
    
    func success(objectIds: [String]) {
        self.removeChannel(objectIds: objectIds)
    }
    func wait(objectIds: [String]) {
        self.removeChannel(objectIds: objectIds)
    }
    
    func setOss(oss: IMOSS) {
        self.oss = oss
    }
    
//    func next() -> Promise<Void> { return Promise<Void>.resolve() }
    func channelMaybeIdle() -> Bool {
        return false
    }
    
    func grab(prog: IMFileProgressModel) { }
    func channelMaybeContainSmallFile() -> Bool {
        return false
    }
    func channelMaybeContain(objectId: String) -> Bool {
        
        var maybeContain: Bool = false
        for downloadingModel in self.downloaders {
            if downloadingModel.prog.objectId == objectId {
                SDKDebugLog("[\(#function)] object already exist in channel, objectId: \(objectId)")
                downloadingModel.downloader.increaseReferenceCount()
                maybeContain = true
                break
            }
        }
        if !maybeContain {
            if self.grabWork.isSame(objectId: objectId) {
                SDKDebugLog("[\(#function)] object is grabing!!, objectId: \(objectId)")
                self.grabWork.increaseGrabTimeCount(objectId: objectId)
                maybeContain = true
            }
        }
        
        return maybeContain
    }
    
    func downloadingObjectIds() -> [String] {
        var ids: [String] = []
        self.downloaders.forEach { tModel in
            ids.append(tModel.prog.objectId)
        }
        return ids
    }
    
    @discardableResult func fileMaybeExist(prog: IMFileProgressModel) -> Bool {
        if let tOss = self.oss {
            
            let docu: String = tOss.ossPath
            let path = docu + prog.objectId
            if FileManager.default.fileExists(atPath: path) {
                SDKDebugLog("[\(self)] [\(#function)] progress data is exist! objectId: \(prog.objectId)")
                let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.big)
                status.success(objectId: prog.objectId)
                return true
            }
            
            return false
        }
        return false
    }
    
    
    private func removeReferenceCount(objectIds: [String]) -> [String] {
        
        var removeObjectIds: [String] = []
        let tMapArr = self.downloaders
        
        for (_, downloadingModel) in tMapArr.enumerated() {
            
            let tObjectId: String = downloadingModel.prog.objectId
            if objectIds.contains(tObjectId) {
                downloadingModel.downloader.reduceReferenceCount()
                if downloadingModel.downloader.getReferenceCount() <= 0 {
                    SDKDebugLog("[\(self)] [\(#function)] remove objectId is: \(tObjectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                    self.downloaders.removeAll { tModel in
                        tModel.prog.objectId == tObjectId
                    }
                    downloadingModel.downloader.cancel(objectId: tObjectId) { }
                    removeObjectIds.append(tObjectId)
                }
            }
            
        }
        SDKDebugLog("[\(self)] [\(#function)] remove objectId done, downloaderMap keys: \(self.downloadingObjectIds())!")
        return removeObjectIds
    }
    
    @discardableResult
    private func removeChannel(objectIds: [String]) -> [String] {
        
        var removeObjectIds: [String] = []
        let tMapArr = self.downloaders
        
        for (_, downloadingModel) in tMapArr.enumerated() {
            
            let tObjectId: String = downloadingModel.prog.objectId
            if objectIds.contains(tObjectId) {
                SDKDebugLog("[\(self)] [\(#function)] remove objectId is: \(tObjectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                self.downloaders.removeAll { tModel in
                    tModel.prog.objectId == tObjectId
                }
                downloadingModel.downloader.cancel(objectId: tObjectId) { }
                removeObjectIds.append(tObjectId)
            }
            
        }
        SDKDebugLog("[\(self)] [\(#function)] remove objectId done, downloaderMap keys: \(self.downloadingObjectIds())!")
        return removeObjectIds
    }
    
    
    private func startGarb(prog: IMFileProgressModel, tOss: IMOSS, dataBase: Database) -> Promise<Void> {
        
        let objectId: String = prog.objectId
        SDKDebugLog("[\(self)] [\(#function)] was excuted, objectId is: \(objectId)!")
        
        let bucketObjectId: String = prog.objectId.replacingOccurrences(of: "t_", with: "")
        let sizeType: IMTransferFileSizeType = IMTransferFileSizeType(rawValue: prog.sizeType) ?? IMTransferFileSizeType.small
        return IMTransferFactory.getDownloader(bucketID: prog.bucketId, ossContext: tOss.ossContext, objectID: bucketObjectId, isNeedNotice: prog.isNeedNotice, deleagte: tOss.deleagte, oss: tOss).then { downloader -> Promise<Void> in
            
            if self.grabWork.isSame(objectId: objectId) == false {
                let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
                status.channelGrabbed(objectId: objectId)
                return Promise<Void>.resolve()
            }
            
            var tempDownloader: IMDownloader = downloader
            tempDownloader.ossPath = tOss.ossPath
            tempDownloader.ossContext = tOss.ossContext
            
            let diffCount: Int = self.grabWork.getGrabTimeCount(objectId: objectId) - tempDownloader.getReferenceCount()
            if diffCount != 0 {
                for _ in 0...diffCount {
                    tempDownloader.increaseReferenceCount()
                }
            }
            
            
            // add into cache arr
            let downloadingModel: IMDownloadingModel = IMDownloadingModel(downloader: tempDownloader, prog: prog)
            self.downloaders.append(downloadingModel)
            SDKDebugLog("[\(self)] intodownload add new! objectId: \(objectId), downloaderMap keys: \(self.downloadingObjectIds())!")
            
            
            if let loader = tempDownloader as? IMThumDownLoader,
               let sence: IMTransferSence = IMTransferSence(rawValue: prog.sourceSence) {
                loader.sourceSence = sence
            }
            
            // start task
            tempDownloader.download(objectID: objectId)
            SDKDebugLog("[\(self)] intodownload start downloading: \(objectId)!")
            
            return Promise<Void>.resolve()
        }.catch { error in
            
            let status = OssDownLoadFactory().create(status: prog.progress, oss: tOss, bucketId: prog.bucketId, sizeType: sizeType)
            status.failed(objectId: objectId)
            return Promise.reject(error)
        }
    }
    
    func into(prog: IMFileProgressModel) {
        
        guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
            dbErrorLog("[\(self)] [\(#function)] context db is nil")
            return
        }
        let objectId: String = prog.objectId
        let tPromise = self.startGarb(prog: prog, tOss: tOss, dataBase: dataBase)
        tPromise.then { _ -> Promise<Void> in
            
            SDKDebugLog("[\(self)] grab call back, current garbObjectIs is \(self.grabWork.getCurrentGarbObjectIds()), objectId is \(objectId)!")
            if self.grabWork.isSame(objectId: objectId) {
                SDKDebugLog("[\(self)] grab call back, grabDone!!")
                self.grabWork.deletGarb(objectId: objectId)
            }
            return Promise<Void>.resolve()
        }.catch { error in
            SDKDebugLog("[\(self)] grab call back, current garbObjectIs is \(self.grabWork.getCurrentGarbObjectIds()), objectId is \(objectId)!")
            if self.grabWork.isSame(objectId: objectId) {
                SDKDebugLog("[\(self)] grab call back, grabDone!!")
                self.grabWork.deletGarb(objectId: objectId)
            }
            return Promise<Void>.reject(error)
        }
        self.grabWork.setGrabObjectId(prog: prog, promise: tPromise)
        
    }
    
    
    func cancelDownloadingBigFileOnNetChange() {
        
    }
    
    func clearAllChannel() {
        
        SDKDebugLog("\(self)] [\(#function)] was executed!!")
        let tDownLoaders = self.downloaders
        self.downloaders.removeAll()
        for downloadingModel in tDownLoaders {
            downloadingModel.downloader.cancel(objectId: downloadingModel.prog.objectId) { }
        }
    }
    
    func startCanleDownloadingBigFile() {
        
        var removeObjectIds: [String] = []
        let tMapArr = self.downloaders
        
        for (_, downloadingModel) in tMapArr.enumerated() {
            
            let tObjectId: String = downloadingModel.prog.objectId
            if downloadingModel.prog.sizeType == IMTransferFileSizeType.big.rawValue {
                SDKDebugLog("[\(self)] [\(#function)] remove DownloadingBigFile, objectId is: \(tObjectId), downloaderMap keys: \(self.downloadingObjectIds())!")
                self.downloaders.removeAll { tModel in
                    tModel.prog.objectId == tObjectId
                }
                downloadingModel.downloader.cancel(objectId: tObjectId) { }
                removeObjectIds.append(tObjectId)
            }
            
        }
        SDKDebugLog("[\(self)] [\(#function)] remove objectId done, downloaderMap keys: \(self.downloadingObjectIds())!")
        
        if removeObjectIds.count != 0 {
            guard let tOss = self.oss, let dataBase = tOss.ossContext.db else {
                dbErrorLog("[\(self)] [\(#function)] context db is nil")
                return
            }
            IMFileProgressDao(db: dataBase).updateProgressWaitToOrderFirstForNetChange(objectIds: removeObjectIds)
        }
    }
    
    
    func next() {
        
    }
    
}


//
//  IMOSS.swift
//  TMM
//
//  Created by Joey on 2022/11/9.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit
import WCDBSwift
import Alamofire

@objcMembers public class IMOSS: NSObject {

    // ms
    static let eventSendIntervalTime: Int = 200
    
    let expirationMaxDay: Int = 3
    
    public var ossContext: IMContext
    public var ossPath: String
    public var downloadControl: IMTransferDownloadControler
    public var uploadControl: IMTransferUploadControler
    private var networkManager: Alamofire.NetworkReachabilityManager?
//    weak var deleagte: IMOSSDelegate?
    private var netStatus = 0
    private var NET_CELLULAR = 0x01
    private var NET_WIFI = 0x02
    public weak var deleagte: IMOSSDelegate?
    
    
    public init(context: IMContext, ossPath: String, delegate: IMOSSDelegate) {
        self.ossContext = context
        self.ossPath = ossPath
        
        self.downloadControl = IMTransferDownloadControler(context: context, ossPath: ossPath)
        self.uploadControl = IMTransferUploadControler(context: context, ossPath: ossPath)
        self.networkManager = NetworkReachabilityManager.init()
        super.init()
        self.addNetworkReachabilityListener()
        self.setDelegate(del: delegate)
        self.downloadControl.setOss(oss: self)
    }
    
    private func setDelegate(del: IMOSSDelegate) {
        self.deleagte = del
        self.uploadControl.setDelegate(del: del)
        self.downloadControl.setDelegate(del: del)
    }
    
    
    static private var defaultInstance: IMOSS?
    public static func defaultOSS() -> IMOSS {
        if defaultInstance == nil {
            defaultInstance = IMOSS(context: IMContext.defualt(), ossPath: IMPathManager.shared.getOssDir(), delegate: IMOSSBaseDelegate())
        }
        return defaultInstance!
    }
    
    // MARK: -

    /// sourceSence: -> TMMTransferSence
//    public func startDownload(objectID: String, bucketId:String, sourceSence: Int, isNeedNotice: Int) {
//
//        guard let dataBase = ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return
//        }
//
//        if objectID.isEmpty || bucketId.isEmpty {
//            SDKDebugLog("TMDownloading error, value is nil！objectID: \(objectID), bucketId: \(bucketId)")
//            return
//        }
//
//        DispatchQueue.main.async {
//
//            var downloadTaskProgress: IMFileProgressModel = IMFileProgressModel()
//            downloadTaskProgress.bucketId = bucketId
//            downloadTaskProgress.objectId = objectID
//            downloadTaskProgress.createTime = Date().milliStamp
//            downloadTaskProgress.sourceSence = sourceSence
//            downloadTaskProgress.isNeedNotice = isNeedNotice
//
//            // set db
//            IMFileProgressDao(db: dataBase).insertFileStatusEntities(fileStatusEntities: [downloadTaskProgress]).then { Void -> Promise<Void> in
//                SDKDebugLog("TMDownloading insert db success！objectID: \(objectID)")
//
//                // downloading task
//                //self.downloadControl.downloading()
//
//                return Promise<Void>.resolve()
//
//            }.catch { error -> Promise<Void> in
//
//                let err = error as! WCDBSwift.Error
//                SDKDebugLog("TMDownloading insert db faliure！objectID: \(objectID), error type: \(err.type), code: \(err.code.value)")
//                if err.type == .sqlite, err.code.value == 19 {
//                    SDKDebugLog("TMDownloading primary key error！objectID: \(objectID), \(err.infos)")
//
//                    var promises: [Promise<Void>] = []
//
//                    // update create time
//                    let updateTimePro: Promise<Void> = IMFileProgressDao(db: dataBase).updateProgressCreateTime(objectId: objectID, time: Date().milliStamp)
//                    promises.append(updateTimePro)
//
//                    // Reset a failed(progerss < 0) task to the wait state
//                    let value: Int = IMFileProgressDao(db: dataBase).queryProgressValueNormal(objectId: objectID)
//                    if value < IMTransferProgressState.start.rawValue {
//                         SDKDebugLog("TMDownloading reset error task state to 'wait' ！objectID: \(objectID)")
//
//                        let updateStatePro:Promise<Void> = IMFileProgressDao(db: dataBase).updateProgressOnStart(objectId: objectID, progress: IMTransferProgressState.wait.rawValue)
//                        promises.append(updateStatePro)
//                    }
//
//
//                    Promise.all(promises).then { Void -> Promise<Void> in
//
//                        // downloading task
//                        //self.downloadControl.downloading()
//
//                        return Promise<Void>.resolve()
//                    }
//                }
//
//                return Promise<Void>.reject(error)
//            }
//        }
//    }
    
    public func startDownload(objectID: String, bucketId:String, isNeedNotice: Int, sizeType: IMTransferFileSizeType) -> Promise<Int> {
        
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        if objectID.isEmpty || bucketId.isEmpty {
            SDKDebugLog("[\(#function)] TMDownloading error, value is nil！objectID: \(objectID), bucketId: \(bucketId)")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        SDKDebugLog("[\(self)] [\(#function)] was started excute!!! objectID is \(objectID)")
        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectID).then { progressModel -> Promise<Int> in
            
            
            var tStatus: Int = IMTransferProgressState.notDown.rawValue
            if let tProgress = progressModel {
                tStatus = tProgress.progress
            }
            
            let status: OssDownLoadStatus = OssDownLoadFactory().create(status: tStatus, oss: self, bucketId: bucketId, sizeType: sizeType, isNeedNotice: isNeedNotice)
            
            let docu: String = self.ossPath
            let path = docu + objectID
            if FileManager.default.fileExists(atPath: path) {
                SDKDebugLog("[\(#function)] TMDownloading wait progress data is exist! objectId: \(objectID)")
                return status.success(objectId: objectID).then { ossStatus -> Promise<Int> in
                    return Promise<Int>.resolve(ossStatus.getDownloadProgress())
                }
            }
            
            return status.startDownload(objectId: objectID).then { ossStatus -> Promise<Int> in
                
                if !self.downloadControl.maybeDownloading(objectId: objectID) {
                    // downloading task
                    self.downloadControl.downloading()
                }
                return Promise<Int>.resolve(ossStatus.getDownloadProgress())
            }
        }
    }
    
    public func grabStartDownload(objectID: String, bucketId:String, isNeedNotice: Int, sizeType: IMTransferFileSizeType) -> Promise<Int> {
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        if objectID.isEmpty || bucketId.isEmpty {
            SDKDebugLog("[\(#function)] TMDownloading error, value is nil！objectID: \(objectID), bucketId: \(bucketId)")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        SDKDebugLog("[\(self)] [\(#function)] was started excute!!! objectID is \(objectID)")
        return IMFileProgressDao(db: dataBase).queryWithObjectId(objectId: objectID).then { progressModel -> Promise<Int> in
            
            
            var tStatus: Int = IMTransferProgressState.notDown.rawValue
            if let tProgress = progressModel {
                tStatus = tProgress.progress
            }
            
            let status: OssDownLoadStatus = OssDownLoadFactory().create(status: tStatus, oss: self, bucketId: bucketId, sizeType: sizeType, isNeedNotice: isNeedNotice)
            
            let docu: String = self.ossPath
            let path = docu + objectID
            if FileManager.default.fileExists(atPath: path) {
                SDKDebugLog("[\(#function)] TMDownloading wait progress data is exist! objectId: \(objectID)")
                return status.success(objectId: objectID).then { ossStatus -> Promise<Int> in
                    return Promise<Int>.resolve(ossStatus.getDownloadProgress())
                }
            }
            
            return status.grabDownload(objectId: objectID).then { ossStatus -> Promise<Int> in
                
                if !self.downloadControl.maybeDownloading(objectId: objectID) {
                    // downloading task
                    self.downloadControl.grabDownloading(objectId: objectID)
                }
                return Promise<Int>.resolve(ossStatus.getDownloadProgress())
            }
        }

    }
    
    public func cancelDownload(objectIds: [String]) {
        
        self.downloadControl.cancelDownload(objectIds: objectIds)
    }
    
    public func pauseDownload(objectId: String) {
        self.downloadControl.pauseDownload(objectId: objectId)
    }
    
    public func isWifi() -> Bool {
        return (self.netStatus & self.NET_WIFI) != 0
    }
    
    public func isWwan() -> Bool {
        return (self.netStatus & self.NET_CELLULAR) != 0
    }
    
    public func isNetworkConnect() -> Bool {
        return isWifi() || isWwan()
    }
    
    
    public func startUpload(objectID: String, bucketId: String) -> Promise<(uploadSuccess: Bool, realBucketId: String?)> {

        // set db
            var newUpload: IMFileProgressModel = IMFileProgressModel()
            newUpload.objectId = objectID
            newUpload.progress = IMTransferProgressState.wait.rawValue
            newUpload.bucketId = bucketId
            newUpload.createTime = Date().milliStamp
            self.uploadControl.uploadProgress.addUploadTask(objectID: objectID, task: newUpload)
            
            let promise = Promise<(uploadSuccess: Bool, realBucketId: String?)> { (resolve, reject) in

                let observer: IMObserver = IMObserver {[weak self] (uploadEvent: IMFileUploadEvent, observer: IMObserver<IMFileUploadEvent>) in
                    guard let self = self else { return }
                    
                    if uploadEvent.objectIds.contains(objectID)  {
        
                        let progress: Int = self.uploadControl.uploadProgress.getProgress(objectId: objectID)
                        if progress == IMTransferProgressState.success.rawValue {
                            
                            let bucketId: String = self.uploadControl.uploadProgress.getProgressBucketID(objectId: objectID)
                            resolve((uploadSuccess: true, realBucketId: bucketId))
        
                            self.uploadControl.ossContext.nc.remove(observer: observer)
                        }
        
                        if (progress < IMTransferProgressState.start.rawValue &&
                            progress > IMTransferProgressState.failureMin.rawValue) ||
                            progress == IMTransferProgressState.fileNotExist.rawValue
                        {
                            resolve((uploadSuccess: false, realBucketId: nil))
        
                            self.uploadControl.ossContext.nc.remove(observer: observer)
                        }
                    }
                }
          
                self.uploadControl.ossContext.nc.addObersver(observer: observer, name: IMFileUploadEvent().getName())
                
                
                
                
                // upload
                self.uploadControl.uploading()
            }
            return promise
    }
    
    

    // MARK: -
    public func queryProgressValueWithEvent(objectId: String) -> Int {
        
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return 0
        }
        
        let value: Int = IMFileProgressDao(db: dataBase).queryProgressValueWithEvent(objectId: objectId)
        return value
    }
    
    public func queryProgressValueNormal(objectId: String) -> Int {
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return 0
        }
        
        let value: Int = IMFileProgressDao(db: dataBase).queryProgressValueNormal(objectId: objectId)
        return value
    }
    
    public func queryUploadProgressValueNormal(objectId: String) -> Int {

        let value: Int = IMFileUploadProgress.shared.getProgress(objectId: objectId)
        return value
    }
    
    func networkMaybeMatch(progressModel: IMFileProgressModel) -> Bool {
        if progressModel.sizeType == IMTransferFileSizeType.small.rawValue {
            return true
        }
        if progressModel.permissionType == IMFileDownloadPermissionType.all.rawValue {
            return true
        }
        if isWifi() {
            return true
        }
        return false
    }
    
    
    public func resetProgress() -> Promise<[String]> {
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(self)] [\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        let time: Int = self.getTimeIntervalBefore(beforDay: self.expirationMaxDay)
        let resetPromise = IMFileProgressDao(db: dataBase).resetDownloadingProgressToWait()
        let deletePromise = IMFileProgressDao(db: dataBase).deleteProgressBy(expirationTime: time, status: [OssDownLoadStatusConstant.pause.rawValue, OssDownLoadStatusConstant.fail.rawValue])
        return Promise.all(resetPromise, deletePromise).then { _, deleteObjectIds -> Promise<[String]> in
            return Promise<[String]>.resolve(deleteObjectIds)
        }
    }
    
    public func resetDoneToStartDownload() {
        self.downloadControl.downloading()
    }
    
    public func deleteProgressForLogout() -> Promise<[String]> {
        guard let dataBase = ossContext.db else {
            dbErrorLog("[\(self)] [\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        self.downloadControl.clearAllChannel()
        return IMFileProgressDao(db: dataBase).deleteProgressByStatus(status: [OssDownLoadStatusConstant.progress.rawValue, OssDownLoadStatusConstant.wait.rawValue])
    }
    
    
    
    func waitDownloadMaybeExpire(progressModel: IMFileProgressModel) -> Bool {
        let diff = self.getTimeIntervalBefore(beforDay: self.expirationMaxDay)
        return progressModel.createTime <= diff
    }
    
    private func getTimeIntervalBefore(beforDay: Int) -> Int {
        let diffTime: Int = beforDay * 24 * 60 * 60 * 1000
        let currentTime: Int = Date().milliStamp
        return (currentTime - diffTime)
    }
    
    private func addNetworkReachabilityListener() {
        
        networkManager?.listener = { [weak self] status in
            guard let self = self else {
                return
            }
            switch status {
            case .reachable(.ethernetOrWiFi):
//                let preHasCellular = self.netStatus & self.NET_CELLULAR
//                if preHasCellular != 0 {
//                    //lose wifi,net change
//                    print("111111111111111111111111 netStatus = \(self.netStatus) ethernetOrWiFi reachable,Cellular lose")
//                    self.netStatus = self.netStatus | (~self.NET_CELLULAR)
//                }
                self.netStatus = self.netStatus | self.NET_WIFI
                NotificationCenter.default.post(name: NSNotification.Name("IsNetworkChange"), object: nil)

                print("111111111111111111111111 wifi reachable")
                break
            case .notReachable:
                let preHasWifi = self.netStatus & self.NET_WIFI
                if preHasWifi != 0 {
                    //lose wifi,net change
                    self.netStatus = self.netStatus & (~self.NET_WIFI)
//                    print("111111111111111111111111 netStatus = \(self.netStatus) notReachable,wifi lose net change")
                    //net change
                    self.downloadControl.networkChange()
                }
                
                let preHasCellular = self.netStatus & self.NET_CELLULAR
                if preHasCellular != 0 {
                    //lose wifi,net change
//                    print("111111111111111111111111 netStatus = \(self.netStatus) notReachable,Cellular lose")
                    self.netStatus = self.netStatus & (~self.NET_CELLULAR)
                }
                NotificationCenter.default.post(name: NSNotification.Name("IsNetworkChange"), object: nil)

                break
            case .unknown:
                
                break
            case .reachable(.wwan):
                let preHasWifi = self.netStatus & self.NET_WIFI
                if preHasWifi != 0 {
                    //lose wifi,net change
                    self.netStatus = self.netStatus & (~self.NET_WIFI)
//                    print("111111111111111111111111 netStatus = \(self.netStatus) wwan reachable,wifi lose net change")
                    
                    //net change
                    self.downloadControl.networkChange()
                
                }
//                print("111111111111111111111111 wwan reachable")
                self.netStatus = self.netStatus | self.NET_CELLULAR
                
                NotificationCenter.default.post(name: NSNotification.Name("IsNetworkChange"), object: nil)

                break
            }
        }
        networkManager?.startListening()
    }
}

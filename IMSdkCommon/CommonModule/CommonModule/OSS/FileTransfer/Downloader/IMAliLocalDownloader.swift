//
//  IMAliLocalDownloader.swift
//  IMSDK
//
//  Created by oceanMAC on 2023/1/13.
//

import Foundation

class IMAliLocalDownloader: IMDownloader {
    var objectParse: IMImageUrlParse?
    var sourceSence:IMTransferSence = IMTransferSence.IM
    var ossPath: String = ""
    var ossContext: IMContext = IMContext()
    weak var deleagte: IMOSSDelegate?
    weak var oss: IMOSS?
    var referenceCount: Int = kDefaultReferenceCount


    func download(objectID: String) {
        
        guard let dataBase = ossContext.db else {
            fatalError("[\(#function)] context db is nil")
            return
        }
        
        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossContext.nc)

        var tempArr: [String] = objectID.components(separatedBy: "/")
        let tempStr: String = tempArr[tempArr.count - 1]
        tempArr = tempStr.components(separatedBy: ".")
        let picName: String = tempArr[0]
        let picSuffix: String = tempArr[tempArr.count - 1]
        
        let newPath: String = Bundle.main.path(forResource: picName, ofType: picSuffix) ?? ""
        let url: URL = URL(fileURLWithPath: newPath)
        SDKDebugLog("本地图片路径\(url)")

        if let newdata = try? Data(contentsOf: url) {
            SDKDebugLog("本地图片存在\(url)")

            let localPath = self.ossPath + objectID
            
            IMPathManager.shared.saveNewDataFile(data: newdata, filePath: localPath)
                .then { saveSuccess -> Promise<Void>  in
                    
                    if saveSuccess {
                        
                        IMFileProgressDao(db: dataBase).updateProgress(objectId: objectID, progress: IMTransferProgressState.success.rawValue).then({ Void -> Promise<Void> in
                            
                            SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectID)")
                            let fileDownloadEvent = IMFileDownloadEvent()
                            fileDownloadEvent.objectIds = [objectID]
                            notificationManager.post(eventProtocol: fileDownloadEvent)
                            return Promise<Void>.resolve()
                        })
                        
                    }else {
                        let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(localPath)"
                        SDKDebugLog(stsStr)
                        
                        IMFileProgressDao(db: dataBase).updateProgressOnError(objectId: objectID, progress: IMTransferProgressState.fileNotExist.rawValue).then({ Void -> Promise<Void> in
                            
                            SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectID)")
                            let fileDownloadEvent = IMFileDownloadEvent()
                            fileDownloadEvent.objectIds = [objectID]
                            notificationManager.post(eventProtocol: fileDownloadEvent)
                            return Promise<Void>.resolve()
                        })
                    }
                    return Promise<Void>.resolve()
                }
            
            return
        }
    
        
        
        let stsStr: String = "TMDownloading local image failure, no match! objectID: \(objectID)"
        SDKDebugLog(stsStr)
        SDKDebugLog("本地图片不存在 \(objectID)")

        IMTransferFactory.getDownloaderIfAliLocalNotExist(bucketID: IMTransferFactory.Local_Bucket_ID, objectID: objectID, ossContext: self.ossContext, deleagte: self.deleagte, oss: self.oss).then { downloader -> Promise<Void> in
            
            var tempDownloader: IMDownloader = downloader
            tempDownloader.ossPath = self.ossPath
            tempDownloader.ossContext = self.ossContext
            tempDownloader.deleagte = self.deleagte
            
            SDKDebugLog("TMDownloading local image get other downloader type: \(type(of: downloader)), and start downloading... objectID: \(objectID)")
            tempDownloader.download(objectID: objectID)
            return Promise<Void>.resolve()
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

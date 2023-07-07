//
//  IMAliCloudApi+download.swift
//  TMMIMSdk
//
//  Created by Joey on 2022/10/17.
//

import Foundation
import AliyunOSSiOS


extension IMAliCloudApi {
    
    
    func downFile(bucketInfoModel : IMBucketInfoModel?,
                  objectId : String,
                  saveOSSPath : String,
                  resolve : @escaping ((IMTransferInfo)->Void)) {
        
        let targetFilePath = saveOSSPath + objectId
        
        let downStr: String = "download file log: objectId: \(objectId), targetFilePath: \(targetFilePath), bucketInfo: \(bucketInfoModel?.toJSONString() ?? "")"
        SDKDebugLog(downStr)
        
        
        let tmTransferInfo = IMTransferInfo()
        tmTransferInfo.objectId = objectId
        tmTransferInfo.progress = 0
        tmTransferInfo.fileStatus = IMFileTransferStatus.Downloading
        
        let failureCallBack: (() -> Void) = {
            tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }
        
        guard let bucketModel = bucketInfoModel else {
            failureCallBack()
            let stsStr: String = "download file log: bucketInfoModel is nil !"
            SDKDebugLog(stsStr)
            return
        }

        guard let bname = bucketModel.bucketName else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no bname!"
            SDKDebugLog(stsStr)
            return
        }


//        guard let region = bucketModel.region else {
//            failureCallBack()
//            let stsStr: String = "download file log: objectId: \(objectId) no region!"
//            SDKDebugLog(stsStr)
//            return
//        }
        
//        let regionType = IMDefine.aws_regionTypeValue(region)
        
//        let stsStr: String = "download file log: objectId: \(objectId) region: \(region), regionType: \(regionType.name)"
//        SDKDebugLog(stsStr)
        
        guard let endPoint = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no endPoint!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let stsModel = STSModel.deserialize(from: bucketModel.sts) else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }
        
        let getObjectReq: OSSGetObjectRequest = OSSGetObjectRequest()
        getObjectReq.bucketName = bname
        getObjectReq.objectKey = objectId
        getObjectReq.downloadProgress = { (bytesWritten: Int64,totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in
            
            // 当前下载长度、当前已下载总长度、待下载的总长度。
            print("bytesWritten:\(bytesWritten),totalBytesWritten:\(totalBytesWritten),totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)");
            
            let progressResult = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100.0
            
            if progressResult - Float(tmTransferInfo.progress) >= 2.0 {

                tmTransferInfo.progress = Int(progressResult - 1)
                let stsStr: String = "ali download file log: objectId: \(objectId) progress: \(tmTransferInfo.progress)"
                SDKDebugLog(stsStr)
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
            }
 
        };
        
        //if clear the document path cache, when downloading file download complete, write file to targate path will failure because temp path not exist
        let myDirectory:String = IMCompressPicManager.deletingLastPathComponent(targetFilePath)
        let fileName:String = IMCompressPicManager.lastPathComponent(targetFilePath)
        let suffix = IMCompressPicManager.pathExtension(targetFilePath)
        let temp = myDirectory + "/" + fileName + String.random(6) + "." + suffix
        let tempPath = IMPathManager.shared.fileCacheDirectory(filePath: temp)
        getObjectReq.downloadToFileURL = URL(fileURLWithPath: tempPath)
        
        let aliClient: OSSClient = self.creatClient(endPoint: endPoint, stsModel: stsModel)
        let task: OSSTask = aliClient.getObject(getObjectReq)
        self.saveOSSRequest(objectId: objectId, request: getObjectReq)
        task.continue({[weak self] (t) -> OSSTask<AnyObject>? in
            guard let self = self else {
                return nil
            }
            
            self.removeOSSRequest(objectId: objectId)
            
            if t.error != nil {
                SDKDebugLog("download file error !!!  objectId: \(objectId) error: \(String(describing: t.error))")
                if t.error!._code == 5 {
                    return nil
                }
                
                if abs(t.error!._code) == 404 {
                    tmTransferInfo.fileStatus = IMFileTransferStatus.Downloading_NoKey
                }else {
                    tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
                }
                tmTransferInfo.progress = 0
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
                
            }else {
                
                SDKDebugLog("download file success !!!  objectId: \(objectId)")

                DispatchQueue.main.async {
                    
                    IMPathManager.shared.saveFileWithOldUrl(tempFile: tempPath, targetFilePath: targetFilePath)
                        .then { saveSuccess -> Promise<Void> in
                            if saveSuccess {
                                
                                let stsStr: String = "download file log: download complete, save Success!! path: \(targetFilePath)"
                                SDKDebugLog(stsStr)
                                
                                tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Success
                                tmTransferInfo.progress = IMTransferProgressState.success.rawValue
                                resolve(tmTransferInfo)
                            }else {
                                
                                let stsStr: String = "download file log: download complete, save failure!! path: \(targetFilePath)"
                                SDKDebugLog(stsStr)
                                
                                tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
                                tmTransferInfo.progress = 0
                                resolve(tmTransferInfo)
                            }
                            return Promise<Void>.resolve()
                        }
                }
            }
            
            return nil
        })
        //task.waitUntilFinished()
        
        SDKDebugLog("download file >> objectId: \(objectId), Error:\(String(describing: task.error))")
    }
    
    
    func downThumbFile(bucketInfoModel : IMBucketInfoModel?,
                       objectId : String,
                       saveOSSPath : String,
                       thumbW: Int,
                       thumbH: Int,
                  resolve : @escaping ((IMTransferInfo)->Void)) {
        
        let targetFilePath = saveOSSPath + objectId
        
        let downStr: String = "download file log: objectId: \(objectId), targetFilePath: \(targetFilePath), bucketInfo: \(bucketInfoModel?.toJSONString() ?? "")"
        SDKDebugLog(downStr)
        
        
        let tmTransferInfo = IMTransferInfo()
        tmTransferInfo.objectId = objectId
        tmTransferInfo.progress = 0
        tmTransferInfo.fileStatus = IMFileTransferStatus.Downloading
        
        let failureCallBack: (() -> Void) = {
            tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }
        
        guard let bucketModel = bucketInfoModel else {
            failureCallBack()
            let stsStr: String = "download file log: bucketInfoModel is nil !"
            SDKDebugLog(stsStr)
            return
        }

        guard let bname = bucketModel.bucketName else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no bname!"
            SDKDebugLog(stsStr)
            return
        }


//        guard let region = bucketModel.region else {
//            failureCallBack()
//            let stsStr: String = "download file log: objectId: \(objectId) no region!"
//            SDKDebugLog(stsStr)
//            return
//        }
        
//        let regionType = IMDefine.aws_regionTypeValue(region)
        
//        let stsStr: String = "download file log: objectId: \(objectId) region: \(region), regionType: \(regionType.name)"
//        SDKDebugLog(stsStr)
        
        guard let endPoint = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no endPoint!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let stsModel = STSModel.deserialize(from: bucketModel.sts) else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }
        
        let tempParse: IMImageUrlParse = IMImageUrlParse.create(url: objectId)
        let originObjectId: String = tempParse.getFileFullName()
        let getObjectReq: OSSGetObjectRequest = OSSGetObjectRequest()
        getObjectReq.bucketName = bname
        getObjectReq.objectKey = originObjectId
        getObjectReq.downloadProgress = { (bytesWritten: Int64,totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in
            
            // 当前下载长度、当前已下载总长度、待下载的总长度。
            print("---->bytesWritten:\(bytesWritten),totalBytesWritten:\(totalBytesWritten),totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)")
            
            let progressResult = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100.0
            if progressResult - Float(tmTransferInfo.progress) >= 2.0 {

                tmTransferInfo.progress = Int(progressResult - 1)

                let stsStr: String = "ali download file log: objectId: \(objectId) progress: \(tmTransferInfo.progress)"
                SDKDebugLog(stsStr)
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
            }
        };
        
        let wStr: String = "w_" + String(thumbW)
        let hStr: String = "h_" + String(thumbH)
        let xOssProcess: String = "image/resize,m_fill," + wStr + "," + hStr
        getObjectReq.xOssProcess = xOssProcess
        
    
        let myDirectory:String = IMCompressPicManager.deletingLastPathComponent(targetFilePath)
        let fileName:String = IMCompressPicManager.lastPathComponent(targetFilePath)
        let suffix = IMCompressPicManager.pathExtension(targetFilePath)
        let temp = myDirectory + "/" + fileName + String.random(6) + "." + suffix
        let tempPath = IMPathManager.shared.fileCacheDirectory(filePath: temp)
        getObjectReq.downloadToFileURL = URL(fileURLWithPath: tempPath)
        
        let aliClient: OSSClient = self.creatClient(endPoint: endPoint, stsModel: stsModel)
        let task: OSSTask = aliClient.getObject(getObjectReq)
        self.saveOSSRequest(objectId: objectId, request: getObjectReq)
        task.continue({[weak self] (t) -> OSSTask<AnyObject>? in
            guard let self = self else {
                return nil
            }
            self.removeOSSRequest(objectId: objectId)
            
            if t.error != nil {
                SDKDebugLog("download file error !!!  objectId: \(objectId) error: \(String(describing: t.error))")

                if t.error!._code == 5 {
                    return nil
                }
                if abs(t.error!._code) == 404 {
                    tmTransferInfo.fileStatus = IMFileTransferStatus.Downloading_NoKey
                }else {
                    tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
                }
                tmTransferInfo.progress = 0
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
                
            }else {
                SDKDebugLog("download file success !!!  objectId: \(objectId)")
                DispatchQueue.main.async {

                    IMPathManager.shared.saveFileWithOldUrl(tempFile: tempPath, targetFilePath: targetFilePath)
                        .then { saveSuccess -> Promise<Void> in
                            if saveSuccess {

                                let stsStr: String = "download file log: download complete, save Success!! path: \(targetFilePath)"
                                SDKDebugLog(stsStr)

                                tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Success
                                tmTransferInfo.progress = IMTransferProgressState.success.rawValue
                                resolve(tmTransferInfo)
                            }else {

                                let stsStr: String = "download file log: download complete, save failure!! path: \(targetFilePath)"
                                SDKDebugLog(stsStr)

                                tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
                                tmTransferInfo.progress = 0
                                resolve(tmTransferInfo)
                            }
                            return Promise<Void>.resolve()
                        }
                }
            }
            
            return nil
        })
        //task.waitUntilFinished()
        
        SDKDebugLog("download file >> objectId: \(objectId), Error:\(String(describing: task.error))")
        
    }
    
}




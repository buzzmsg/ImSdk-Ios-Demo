//
//  IMAWSUploadDownManager+download.swift
//  TMM
//
//  Created by  on 2022/5/12.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation


extension IMAWSUploadDownManager {
    
    //down
    public func downFile(bucketInfoModel : IMBucketInfoModel?,
                         objectId : String,
                         saveOSS : IMOSS,
                         deleagte: IMOSSDelegate?,
                         resolve : @escaping ((IMTransferInfo)->Void)) {
        
        //IMBucketManager().getSelfBucket(context: saveOSS.ossContext).then { bucket -> Promise<Void> in
        deleagte!.getSelfBucket().then { bucket -> Promise<Void> in
            guard let startbucket = bucket else {
                return Promise<Void>.resolve()
            }
            
            // is exist
            let docu: String = saveOSS.ossPath

            let path = docu + objectId
            if FileManager.default.fileExists(atPath: path) {
                SDKDebugLog("TMDownloading getSelfBucket data is exist! - 3 objectId: \(objectId)")
                return Promise<Void>.resolve()
            }
            
            self.setupDownFile(bucketInfoModel: bucketInfoModel, objectId: objectId, isAccelerate:startbucket.is_accelerate, saveOSSPath: docu, resolve: resolve)
            return Promise<Void>.resolve()
        }
    }
    
    private func setupDownFile(bucketInfoModel : IMBucketInfoModel?,
                               objectId : String,
                               isAccelerate : Bool,
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
        
        guard let sts = bucketModel.sts else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no sts!"
            SDKDebugLog(stsStr)
            return
        }

        guard let bname = bucketModel.bucketName else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no bname!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard var action = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no action!"
            SDKDebugLog(stsStr)
            return
        }
        action = action.replacingOccurrences(of: bname + ".", with: "")


        guard let region = bucketModel.region else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }
        
        let regionType = IMAwsUtil.aws_regionTypeValue(region)
        
        let stsStr: String = "download file log: objectId: \(objectId) region: \(region), regionType: regionType.name"
        SDKDebugLog(stsStr)
        
        
        let dic = self.stringValueDic(sts)
        guard let access_key = dic?["access_key_id"] as? String ,access_key.count > 0 else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no access_key_id!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let access_key_secret = dic?["access_key_secret"] as? String,access_key_secret.count > 0 else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no access_key_secret!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let session_token = dic?["session_token"] as? String,session_token.count > 0 else {
            failureCallBack()
            let stsStr: String = "download file log: objectId: \(objectId) no session_token!"
            SDKDebugLog(stsStr)
            return
        }
          
        var transferUtility: AWSS3TransferUtility?
        
        if let transfer = AWSS3TransferUtility.s3TransferUtility(forKey: objectId) {
            transferUtility = transfer
        }else {
           
            let credentialsProvider = AWSBasicSessionCredentialsProvider.init(accessKey: access_key, secretKey: access_key_secret, sessionToken: session_token)
            
            let configuration = AWSServiceConfiguration.init(region: regionType, credentialsProvider: credentialsProvider)
    //        let endPoint: AWSEndpoint = AWSEndpoint.init(urlString: String(format: "https://%@.s3-accelerate.amazonaws.com", bucketModel.bucketName ?? ""))
    //        let configuration = AWSServiceConfiguration.init(region: regionType, endpoint: endPoint, credentialsProvider: credentialsProvider)
            
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            let transferUtilityConfiguration = AWSS3TransferUtilityConfiguration.init()
//            transferUtilityConfiguration.isAccelerateModeEnabled = isAccelerate
            transferUtilityConfiguration.retryLimit = 10
            transferUtilityConfiguration.timeoutIntervalForResource = 86400
            
            AWSS3TransferUtility.register(with: configuration ?? AWSServiceConfiguration(), forKey: objectId) { error in
                
            }
//            AWSS3TransferUtility.register(with: configuration ?? AWSServiceConfiguration(), transferUtilityConfiguration: transferUtilityConfiguration , forKey: objectId)
            
            transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectId)
        }
        

        let expression = AWSS3TransferUtilityDownloadExpression.init()
        expression.progressBlock = { task, progress in
            let progressResult = progress.fractionCompleted * 100 - 1
            
            if progressResult >= 100 {
                let stsStr: String = "download file log: objectId: \(objectId) progress: done!"
                    SDKDebugLog(stsStr)
            } else {
                let stsStr: String = "download file log: objectId: \(objectId) progress: \(progressResult)"
                    SDKDebugLog(stsStr)
            }

            if targetFilePath.isEmpty {
                return
            }
            DispatchQueue.main.async {
                
                tmTransferInfo.progress = Int(progressResult)
                resolve(tmTransferInfo)
            }
        }

        let startStr: String = "download file log: download start..... targetFilePath: \(targetFilePath)"
        SDKDebugLog(startStr)
        
        let myDirectory:String = IMCompressPicManager.deletingLastPathComponent(targetFilePath)
        let fileName:String = IMCompressPicManager.lastPathComponent(targetFilePath)
        let suffix = IMCompressPicManager.pathExtension(targetFilePath)
        let temp = myDirectory + "/" + fileName + String.random(6) + "." + suffix
        let tempPath = IMPathManager.shared.fileCacheDirectory(filePath: temp)
//        let tempPath = IMPathManager.shared.getOssDir() + temp

        transferUtility?.download(to: URL(fileURLWithPath: tempPath), bucket: bucketModel.bucketName ?? "", key: objectId, expression: expression, completionHandler: { task, url, data, error in
            let stsStr: String = "download file log: download end!! path: \(targetFilePath)"
            SDKDebugLog(stsStr)
            guard let _ = error else {
                DispatchQueue.main.async {
                    if let tempUrl = url {
                        IMPathManager.shared.saveFileWithOldUrl(tempFile: tempUrl.path, targetFilePath: targetFilePath)
                            .then { saveSuccess -> Promise<Void> in
                                if saveSuccess {
                                   
                                    let stsStr: String = "download file log: download complete, save Success!! path: \(targetFilePath),awsTempPath:\(tempUrl.path)"
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
                    }else {
                        let stsStr: String = "download file log: download complete, save failure!! path: \(targetFilePath),awsTempPath:\(url)"
                                                SDKDebugLog(stsStr)
                        
                        tmTransferInfo.fileStatus = IMFileTransferStatus.Download_Failed
                        tmTransferInfo.progress = 0
                        resolve(tmTransferInfo)
                    }
                }
                return
            }
            

            if task.response?.statusCode == 404 {
                let stsStr: String = "download file log: download no key!! path: \(targetFilePath)"
                SDKDebugLog(stsStr)
                tmTransferInfo.fileStatus = IMFileTransferStatus.Downloading_NoKey
                tmTransferInfo.progress = 0
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
                return
            }
            failureCallBack()

            var log = "\n============================= Download Image Failed =========================\n\n"
            log += "dic:               \(String(describing: dic))\n"
            log += "key:               \(objectId)\n"
            log += "bucketName:               \(String(describing: bucketModel.bucketName))\n"
            log += "action:               \(action)\n"
            log += "regionType:               \(IMAwsUtil.aws_regionTypeValue(region))\n"
            log += "region:               \(region)\n"
            log += "error:               \(String(describing: error))\n"

                log += "\n=============================================================================\n"
            
            if let e = error as NSError? {
                SDKDebugLog("---download file log error:\(e.code)")
            }
            SDKDebugLog(log)
        }).continueWith(block: { continueTask in
            if continueTask.error != nil {
                
                AWSS3TransferUtility.remove(forKey: objectId as String)
                failureCallBack()
                
                let stsStr: String = "download file log: download file ready faliure!!! path: \(targetFilePath), error: \(continueTask.error)"
                SDKDebugLog(stsStr)
                
            }else {
                let stsStr: String = "download file log: download file ready...... path: \(targetFilePath)"
                SDKDebugLog(stsStr)
            }
            return nil
        })
        
    }
    
    
   
    
    func cancleDownloadTask(objectID: String, success: @escaping CancleTaskSuccess) {
        
        if IMThread.current != IMThread.main {
            SDKDebugLog("cancleDownloadTask must be called in mainThread")
            dbErrorLog("cancleDownloadTask must be called in mainThread");
        }
        
        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectID) else {
            return
        }
        
        let allDownTasks = transferUtility.getDownloadTasks().result
//        let allMultiPartUploadTasks = transferUtility.getMultiPartUploadTasks().result
        if allDownTasks?.count != 0 {
            
            AWSS3TransferUtility.remove(forKey: objectID)

            self.cancleDownloadSuccessBlockMap[transferUtility] = success
            SDKDebugLog("Cancel Download aws task! objectID: \(objectID)")

        }
        
        
//        SDKDebugLog("Cancel aws task! objectID: \(objectID)")
//        AWSS3TransferUtility.remove(forKey: objectID)
        /*
        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectID) else {
            return
        }
        
        if let allDownloadTasks = transferUtility.getDownloadTasks().result {
            
            allDownloadTasks.forEach { task in
                
                if let downloadTask = task as? AWSS3TransferUtilityDownloadTask {
                    downloadTask.cancel()
                }
            }
        }
        */
    }
    
}

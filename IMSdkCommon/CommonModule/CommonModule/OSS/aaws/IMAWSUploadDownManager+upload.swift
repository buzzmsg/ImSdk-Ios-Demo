//
//  IMAWSUploadDownManager+upload.swift
//  TMM
//
//  Created by  on 2022/5/12.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

extension IMAWSUploadDownManager {
    
    
    //upload
    func uploadFile(bucketInfoModel : IMBucketInfoModel?,
                    filePath : String,
                    objectId : String,
                    saveOSS : IMOSS,
                    deleagte: IMOSSDelegate?,
                    resolve : @escaping ((IMTransferInfo)->Void))
    {
        
        let logStr: String = "Send imagefile ---> get buckInfo done! currentTime: \(Date().milliStamp)；buckId:\(bucketInfoModel?.bucketId); bucketName:\(bucketInfoModel?.bucketName), objectId:\(objectId)"
        SDKDebugLog(logStr)
        
        //IMBucketManager().getSelfBucket(context: saveOSS.ossContext).then { bucket -> Promise<Void> in
        deleagte!.getSelfBucket().then { bucket -> Promise<Void> in
            guard let startbucket = bucket else {
                return Promise<Void>.resolve()
            }
            
            if let attributes: [FileAttributeKey : Any] = try? FileManager.default.attributesOfItem(atPath: filePath) {
                let dic = NSDictionary(dictionary: attributes)
                let fileSize = dic.fileSize()
                let maxSize: UInt64 = 5 * 1024 * 1024
                
                if fileSize > maxSize {
                    
                    self.awsMultiUpload(bucketInfoModel: bucketInfoModel, filePath: filePath, objectId: objectId, isAccelerate:startbucket.is_accelerate, resolve: resolve)
                    return Promise<Void>.resolve()
                }
                self.awsUpload(bucketInfoModel: bucketInfoModel, filePath: filePath, objectId: objectId, isAccelerate:startbucket.is_accelerate, resolve: resolve)
            }
            return Promise<Void>.resolve()
        }
        
    }
    
    private func awsUpload(bucketInfoModel : IMBucketInfoModel?,
                           filePath : String,
                           objectId : String,
                           isAccelerate : Bool,
                           resolve : @escaping ((IMTransferInfo)->Void))
    {
        let tmTransferInfo = IMTransferInfo()
        tmTransferInfo.progress = 0
        tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading
        tmTransferInfo.bucketId = bucketInfoModel?.bucketId ?? ""
        
        let failureCallBack: (() -> Void) = {
            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }
        
        guard let bucketModel = bucketInfoModel else {
            failureCallBack()
            let stsStr: String = "upload file log: bucketInfoModel is nil !"
            SDKDebugLog(stsStr)
            return
        }
                
        guard let bname = bucketModel.bucketName else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no bname!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard var action = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no action!"
            SDKDebugLog(stsStr)
            return
        }

        action = action.replacingOccurrences(of: bname + ".", with: "")
        

        guard let region = bucketModel.region else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }
        
        let regionType = IMAwsUtil.aws_regionTypeValue(region)


        let stsStr: String = "upload file log: objectId: \(objectId) region: \(region), regionType: regionType.name"
        SDKDebugLog(stsStr)
        
        
        let dic = self.stringValueDic(bucketModel.sts!)
        guard let access_key = dic?["access_key_id"] as? String ,access_key.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no access_key_id!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let access_key_secret = dic?["access_key_secret"] as? String,access_key_secret.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no access_key_secret!"
            SDKDebugLog(stsStr)
            return
        }
        
        guard let session_token = dic?["session_token"] as? String,session_token.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no session_token!"
            SDKDebugLog(stsStr)
            return
        }
        
        let credentialsProvider = AWSBasicSessionCredentialsProvider.init(accessKey: access_key, secretKey: access_key_secret, sessionToken: session_token)
        let configuration: AWSServiceConfiguration = AWSServiceConfiguration.init(region: regionType, credentialsProvider: credentialsProvider) ?? AWSServiceConfiguration()
        
        
        //let endPoint: AWSEndpoint = AWSEndpoint.init(region: regionType, service: AWSServiceType.S3, useUnsafeURL: false)
        //let configuration = AWSServiceConfiguration.init(region: regionType, endpoint: endPoint, credentialsProvider: credentialsProvider) ?? AWSServiceConfiguration()
        let transferUtilityConfiguration = AWSS3TransferUtilityConfiguration()
        transferUtilityConfiguration.bucket = bucketModel.bucketName
        //transferUtilityConfiguration.isAccelerateModeEnabled = isAccelerate
        //transferUtilityConfiguration.retryLimit = 10
        //transferUtilityConfiguration.timeoutIntervalForResource = 86400
        AWSS3TransferUtility.register(with: configuration, transferUtilityConfiguration: transferUtilityConfiguration , forKey: objectId)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        

        let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectId)
        let contentType = self.mimeType(pathExtension: filePath as String)
        
        let expression: AWSS3TransferUtilityUploadExpression = AWSS3TransferUtilityUploadExpression.init()
        expression.progressBlock = { (task, progress) in
            let progressResult = progress.fractionCompleted * 100
            
            let logStr: String = "Send imagefile ---> aws uploading(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),progress: \(progressResult)"
            SDKDebugLog(logStr)
            
            tmTransferInfo.progress = Int(progressResult - 1)
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }
        
        let logStr: String = "Send imagefile ---> aws pre-start send!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId)"
        SDKDebugLog(logStr)

        
        transferUtility?.uploadFile(URL(fileURLWithPath: filePath), bucket: bucketModel.bucketName ?? "", key: objectId, contentType: contentType, expression: expression, completionHandler: { task, error in
            
            let stsStr: String = "upload file log: upload end!! path: \(filePath), task bucket: \(task.bucket), task id: \(task.transferID), task status: \(task.status.rawValue), task complete count: \(task.progress.completedUnitCount), task total count: \(task.progress.totalUnitCount)"
            SDKDebugLog(stsStr)
            
            AWSS3TransferUtility.remove(forKey: objectId)
            guard let uploadError = error, task.status != .completed else {

                let logStr: String = "Send imagefile ---> aws upload done success!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
                SDKDebugLog(logStr)
                
                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
                tmTransferInfo.progress = 100
                
                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
                
                return
            }
            
            failureCallBack()

            let logStr: String = "Send imagefile ---> aws upload done failure!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),error: \(uploadError)"
            SDKDebugLog(logStr)
            
        }).continueWith(block: { continueTask in
            
            if continueTask.error != nil {
                AWSS3TransferUtility.remove(forKey: objectId)
                failureCallBack()
                
                let logStr: String = "Send imagefile ---> aws pre-upload failure!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),error: \(continueTask.error)"
                SDKDebugLog(logStr)

            }else {
                let logStr: String = "Send imagefile ---> aws start send!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId)path: \(filePath)"
                SDKDebugLog(logStr)
            }
            
            return nil
        }).waitUntilFinished()
        
    }
    
    
    private func awsMultiUpload(bucketInfoModel : IMBucketInfoModel?,
                                filePath : String,
                                objectId : String,
                                isAccelerate : Bool,
                                resolve : @escaping ((IMTransferInfo)->Void))
    {
        let tmTransferInfo = IMTransferInfo()
        tmTransferInfo.progress = 0
        tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading
        tmTransferInfo.bucketId = bucketInfoModel?.bucketId ?? ""
        
        
        let failureCallBack: (() -> Void) = {
            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }
        
        guard let bucketModel = bucketInfoModel else {
            failureCallBack()
            let stsStr: String = "upload file log: bucketInfoModel is nil !"
            SDKDebugLog(stsStr)
            return
        }

        guard let bname = bucketModel.bucketName else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no bname!"
            SDKDebugLog(stsStr)
            return
        }

        guard var action = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no action!"
            SDKDebugLog(stsStr)
            return
        }

        action = action.replacingOccurrences(of: bname + ".", with: "")


        guard let region = bucketModel.region else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }

        let regionType = IMAwsUtil.aws_regionTypeValue(region)


        let stsStr: String = "upload file log: objectId: \(objectId) region: \(region), regionType: regionType.name"
        SDKDebugLog(stsStr)


        let dic = self.stringValueDic(bucketModel.sts!)
        guard let access_key = dic?["access_key_id"] as? String ,access_key.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no access_key_id!"
            SDKDebugLog(stsStr)
            return
        }

        guard let access_key_secret = dic?["access_key_secret"] as? String,access_key_secret.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no access_key_secret!"
            SDKDebugLog(stsStr)
            return
        }

        guard let session_token = dic?["session_token"] as? String,session_token.count > 0 else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no session_token!"
            SDKDebugLog(stsStr)
            return
        }

        let credentialsProvider = AWSBasicSessionCredentialsProvider.init(accessKey: access_key, secretKey: access_key_secret, sessionToken: session_token)

        let configuration = AWSServiceConfiguration.init(region: regionType, credentialsProvider: credentialsProvider)
        
        let transferUtilityConfiguration = AWSS3TransferUtilityConfiguration.init()
        //transferUtilityConfiguration.isAccelerateModeEnabled = isAccelerate
        //transferUtilityConfiguration.retryLimit = 10
        //transferUtilityConfiguration.timeoutIntervalForResource = 86400

        AWSS3TransferUtility.register(with: configuration ?? AWSServiceConfiguration(), transferUtilityConfiguration: transferUtilityConfiguration , forKey: objectId)

        let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectId)
        let contentType = self.mimeType(pathExtension: filePath as String)

        let expression = AWSS3TransferUtilityMultiPartUploadExpression.init()
        expression.progressBlock = { (task, progress) in
            let progressResult = progress.fractionCompleted * 100
            
            let logStr: String = "Send imagefile ---> aws uploading(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),progress: \(progressResult)"
            SDKDebugLog(logStr)

            tmTransferInfo.progress = Int(progressResult - 1)
            DispatchQueue.main.async {
                resolve(tmTransferInfo)
            }
        }


        let logStr: String = "Send imagefile ---> aws pre-start send!(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId)"
        SDKDebugLog(logStr)

        
        transferUtility?.uploadUsingMultiPart(fileURL: URL(fileURLWithPath: filePath), bucket: bucketModel.bucketName ?? "", key: objectId as String, contentType: contentType, expression: expression, completionHandler: { task, error in

            let stsStr: String = "upload file log: upload end!! path: \(filePath), task bucket: \(task.bucket), task id: \(task.transferID), task status: \(task.status.rawValue), task complete count: \(task.progress.completedUnitCount), task total count: \(task.progress.totalUnitCount)"
            SDKDebugLog(stsStr)

            AWSS3TransferUtility.remove(forKey: objectId)
            guard let uploadError = error, task.status != .completed else {

                let logStr: String = "Send imagefile ---> aws upload done success!(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
                SDKDebugLog(logStr)

                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
                tmTransferInfo.progress = 100

                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }

                return
            }
            
            failureCallBack()
            
            let logStr: String = "Send imagefile ---> aws upload done failure!(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),error: \(uploadError)"
            SDKDebugLog(logStr)

        }).continueWith(block: { continueTask in

            if continueTask.error != nil {

                let logStr: String = "Send imagefile ---> aws pre-upload failure!(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),error: \(continueTask.error)"
                SDKDebugLog(logStr)


                AWSS3TransferUtility.remove(forKey: objectId)
                failureCallBack()
                
            }else {
                let logStr: String = "Send imagefile ---> aws start send!(multi part) currentTime: \(Date().milliStamp), objectId:\(objectId)path: \(filePath)"
                SDKDebugLog(logStr)
            }

            return nil
        })

    }
    
    func cancleUploadTask(objectID: String, success: @escaping CancleTaskSuccess) {

        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectID) else {
            return
        }
        
        let allUploadTasks = transferUtility.getUploadTasks().result
        let allMultiPartUploadTasks = transferUtility.getMultiPartUploadTasks().result
        if allUploadTasks?.count != 0 || allMultiPartUploadTasks?.count != 0 {
            
            AWSS3TransferUtility.remove(forKey: objectID)
            self.cancleDownloadSuccessBlockMap[transferUtility] = success
            SDKDebugLog("Cancel Upload aws task! objectID: \(objectID)")
        }

        /*
         guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: objectID) else {
         return
         }
         
         // single
         if let allUploadTasks = transferUtility.getUploadTasks().result {
         
         allUploadTasks.forEach { task in
         
         if let uploadTask = task as? AWSS3TransferUtilityUploadTask {
         uploadTask.cancel()
         }
         }
         }
         
         //multi
         if let allMultiPartUploadTasks = transferUtility.getMultiPartUploadTasks().result {
         
         allMultiPartUploadTasks.forEach { task in
         
         if let multiUploadTask = task as? AWSS3TransferUtilityMultiPartUploadTask {
         multiUploadTask.cancel()
         
         }
         
         }
         
         }
         */
    }
    
}

//
//  IMAliCloudApi+upload.swift
//  TMMIMSdk
//
//  Created by Joey on 2022/10/17.
//

import Foundation
import AliyunOSSiOS

extension IMAliCloudApi {
    
    func uploadFile(bucketInfoModel : IMBucketInfoModel?,
                    filePath : String,
                    objectId : String,
                    resolve : @escaping ((IMTransferInfo)->Void)) {
        
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
        
        guard let endPoint = bucketModel.baseHost else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no action!"
            SDKDebugLog(stsStr)
            return
        }

//        action = action.replacingOccurrences(of: bname + ".", with: "")
    
        
        
        guard let stsModel = STSModel.deserialize(from: bucketModel.sts) else {
            failureCallBack()
            let stsStr: String = "upload file log: objectId: \(objectId) no region!"
            SDKDebugLog(stsStr)
            return
        }
        
        let aliClient: OSSClient = self.creatClient(endPoint: endPoint, stsModel: stsModel)
        
        Promise<Void>.resolve(()).thenByThread { Void -> Bool in
            
            let result: ()? = try? aliClient.doesObjectExist(inBucket: bname, objectKey: objectId)
            return ((result != nil) as Bool)
            
        }.then { [weak self] objectExist -> Promise<Void> in
            guard let self = self else {
                return Promise<Void>.resolve()
            }
            if objectExist {
                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
                tmTransferInfo.progress = 100

                DispatchQueue.main.async {
                    resolve(tmTransferInfo)
                }
                return Promise<Void>.resolve()
            }
            
            if let attributes: [FileAttributeKey : Any] = try? FileManager.default.attributesOfItem(atPath: filePath) {
                let dic = NSDictionary(dictionary: attributes)
                let fileSize = dic.fileSize()
                let maxSize: UInt64 = 5 * 1024 * 1024
                
                if fileSize > maxSize {
                    
                    let request = OSSPutObjectRequest()
                    request.uploadingFileURL = URL(fileURLWithPath: filePath)
                    request.bucketName = bname
                    request.objectKey = objectId
                    
                    request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in

                        let progressResult = (Float(totalBytesSent) / Float(totalBytesExpectedToSend)) * 100.0
                        tmTransferInfo.progress = Int(progressResult - 1)
                        DispatchQueue.main.async {
                            resolve(tmTransferInfo)
                        }
                        
                        SDKDebugLog("bytesSent:\(bytesSent), totalBytesSent:\(totalBytesSent), totalBytesExpectedToSend:\(totalBytesExpectedToSend), progress: \(progressResult)")
                    };
                    
                    let task = aliClient.putObject(request)
                    self.saveOSSRequest(objectId: objectId, request: request)
                    task.continue({ (t) -> Any? in
                        
                        self.removeOSSRequest(objectId: objectId)
                        
                        if t.error != nil {
                            print("阿里云上传失败 ---> \(String(describing: t.error))")
                            
                            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
                            DispatchQueue.main.async {
                                resolve(tmTransferInfo)
                            }
                            
                        }else {
                            print("阿里云上传成功")
                            
                            let logStr: String = "Send imagefile ---> aws upload done success!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
                            SDKDebugLog(logStr)
                            
                            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
                            tmTransferInfo.progress = IMTransferProgressState.success.rawValue
                            
                            DispatchQueue.main.async {
                                resolve(tmTransferInfo)
                            }
                        }
                        return nil
                    })
                    
                }else {
                    
                    let request = OSSMultipartUploadRequest()
                    request.uploadingFileURL = URL(fileURLWithPath: filePath)
                    request.bucketName = bname
                    request.objectKey = objectId
                    request.partSize = 102400;
                    request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                        
                        let progressResult = (Float(totalBytesSent) / Float(totalBytesExpectedToSend)) * 100.0
                        tmTransferInfo.progress = Int(progressResult - 1)
                        DispatchQueue.main.async {
                            resolve(tmTransferInfo)
                        }
                        
                        SDKDebugLog("bytesSent:\(bytesSent), totalBytesSent:\(totalBytesSent), totalBytesExpectedToSend:\(totalBytesExpectedToSend), progress: \(progressResult)")
                    }
                    
                    let task = aliClient.multipartUpload(request)
                    self.saveOSSRequest(objectId: objectId, request: request)
                    task.continue({ (t) -> Any? in
                        
                        self.removeOSSRequest(objectId: objectId)
                        
                        if t.error != nil {
                            SDKDebugLog("阿里云上传失败 ---> \(String(describing: t.error))")
                            
                            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
                            DispatchQueue.main.async {
                                resolve(tmTransferInfo)
                            }
                            
                        }else {
                            
                            let logStr: String = "Send imagefile ---> aws upload done success!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
                            SDKDebugLog(logStr)
                            
                            tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
                            tmTransferInfo.progress = IMTransferProgressState.success.rawValue
                            
                            DispatchQueue.main.async {
                                resolve(tmTransferInfo)
                            }
                        }
                        return nil
                    })
                    
                }
                
            }
            
            return Promise<Void>.resolve()
        }
        
        
        
//        IMBucketManager().getSelfBucket().then { bucket -> Promise<Void> in
//            guard let startbucket = bucket else {
//                return Promise<Void>.resolve()
//            }
//
//            if let attributes: [FileAttributeKey : Any] = try? FileManager.default.attributesOfItem(atPath: filePath) {
//                let dic = NSDictionary(dictionary: attributes)
//                let fileSize = dic.fileSize()
//                let maxSize: UInt64 = 5 * 1024 * 1024
//
//                if fileSize > maxSize {
//
//                    self.multiUpload(bucketInfoModel: bucketModel, filePath: filePath, objectId: objectId, isAccelerate:startbucket.is_accelerate, tmTransferInfo: tmTransferInfo, resolve: resolve)
//                    return Promise<Void>.resolve()
//                }
//                self.upload(bucketInfoModel: bucketModel, filePath: filePath, objectId: objectId, isAccelerate:startbucket.is_accelerate, tmTransferInfo: tmTransferInfo, resolve: resolve)
//            }
//            return Promise<Void>.resolve()
//        }
    }
    
    
    private func upload(bucketInfoModel : IMBucketInfoModel,
                           filePath : String,
                           objectId : String,
                        isAccelerate : Bool,
                        tmTransferInfo: IMTransferInfo,
                           resolve : @escaping ((IMTransferInfo)->Void))
    {
        
//        let request = OSSPutObjectRequest()
//        request.uploadingFileURL = URL(fileURLWithPath: filePath)
//        request.bucketName = bucketInfoModel.bucketName ?? ""
//        request.objectKey = objectId
//
//        request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
//
//            // 当前上传长度、当前已上传总长度、待上传的总长度。
//            print("bytesSent:\(bytesSent),totalBytesSent:\(totalBytesSent),totalBytesExpectedToSend:\(totalBytesExpectedToSend)")
//
//
////            let logStr: String = "Send imagefile ---> aws uploading(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),progress: \(progressResult)"
////            SDKDebugLog(logStr)
//
//            var progressResult = (Float(totalBytesSent) / Float(totalBytesExpectedToSend)) * 100.0
//            DispatchQueue.main.async {
//
//                tmTransferInfo.progress = Int(progressResult - 1)
//                resolve(tmTransferInfo)
//            }
//
//        };
//
//        let task = self.client!.putObject(request)
//        task.continue({ (t) -> Any? in
//
//            if t.error != nil {
//                print("阿里云上传失败 ---> \(String(describing: t.error))")
//
//                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
//                DispatchQueue.main.async {
//                    resolve(tmTransferInfo)
//                }
//
//            }else {
//                print("阿里云上传成功")
//
////                let logStr: String = "Send imagefile ---> aws upload done success!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
////                SDKDebugLog(logStr)
//
//                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Success
//                tmTransferInfo.progress = IMTransferProgressState.success.rawValue
//
//                DispatchQueue.main.async {
//                    resolve(tmTransferInfo)
//                }
//            }
//            return nil
//        })
        //task.waitUntilFinished()
        
    }
    
    
    private func multiUpload(bucketInfoModel : IMBucketInfoModel,
                                filePath : String,
                                objectId : String,
                                isAccelerate : Bool,
                             tmTransferInfo: IMTransferInfo,
                                resolve : @escaping ((IMTransferInfo)->Void))
    {
//        OSSMultipartUploadRequest
//        OSSInitMultipartUploadResult
        
        
//        let request = OSSMultipartUploadRequest()
//        request.uploadingFileURL = URL(fileURLWithPath: filePath)
//        request.bucketName = bucketInfoModel.bucketName ?? ""
//        request.objectKey = objectId
//        request.partSize = 102400;
//        request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
//            print("bytesSent:\(bytesSent),totalBytesSent:\(totalBytesSent),totalBytesExpectedToSend:\(totalBytesExpectedToSend)")
//
////            let logStr: String = "Send imagefile ---> aws uploading(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath),progress: \(progressResult)"
////            SDKDebugLog(logStr)
//
//            let progressResult = (Float(totalBytesSent) / Float(totalBytesExpectedToSend)) * 100.0
//            DispatchQueue.main.async {
//
//                tmTransferInfo.progress = Int(progressResult - 1)
//                resolve(tmTransferInfo)
//            }
//        }
//        let task = self.client!.multipartUpload(request)
//        task.continue({ (t) -> Any? in
//            if t.error != nil {
//                print("阿里云上传失败 ---> \(String(describing: t.error))")
//
//                tmTransferInfo.fileStatus = IMFileTransferStatus.Uploading_Failed
//                DispatchQueue.main.async {
//                    resolve(tmTransferInfo)
//                }
//
//            }else {
//                print("阿里云上传成功")
//
////                let logStr: String = "Send imagefile ---> aws upload done success!(all part) currentTime: \(Date().milliStamp), objectId:\(objectId),path: \(filePath)"
////                SDKDebugLog(logStr)
//
//                tmTransferInfo.fileStatus = TmFileTransferStatus.Uploading_Success
//                tmTransferInfo.progress = IMTransferProgressState.success.rawValue
//
//                DispatchQueue.main.async {
//                    resolve(tmTransferInfo)
//                }
//            }
//            return nil
//        })
        //.waitUntilFinished()
    }
    
}



//
//  IMAWSUploadDownManager.swift
//  TMM
//
//  Created by  on 2021/8/7.
//  Copyright © 2021 TMM. All rights reserved.
//

import UIKit
import MobileCoreServices
import AWSCore
import AWSS3

protocol IMCallSuccessBack {
    func success(success:AWSS3TransferUtilityUploadTask)
}

protocol IMCallFailBack {
    func fail(fail:Error)
}

protocol IMCallSuccessBlock {
    func success(success:AWSS3TransferUtilityDownloadTask,url:NSURL,fileData:NSData)
}

public typealias FileTransferSuccess = (_ path : String) -> Void
public typealias FileTransferFailed = (_ error : Error) -> Void
public typealias FileTransferProgress = (_ id : String ,_ progress : Int) -> Void
public typealias CancleTaskSuccess = () -> Void

class IMAWSUploadDownManager {

    static let `default` = IMAWSUploadDownManager()

    var uploadDone: [[String : (IMTransferInfo) -> Void]] = []
    var cancleDownloadSuccessBlockMap: [AWSS3TransferUtility : CancleTaskSuccess] = [:]
    
    
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(AWSS3TransferUtilityURLSessionDidBecomeInvalid(notifcation:)), name: NSNotification.Name.AWSS3TransferUtilityURLSessionDidBecomeInvalid, object: nil)
    }
    
    @objc func AWSS3TransferUtilityURLSessionDidBecomeInvalid(notifcation: Notification) {
        if let transferUtility = notifcation.object as? AWSS3TransferUtility {
            
            DispatchQueue.main.async {
                if let block = self.cancleDownloadSuccessBlockMap[transferUtility] {
                    block()
                }
            }

        }
    }
    
    //changge-sts
    public func stringValueDic(_ sts: String) -> [String : Any]?{
             
        if let data = sts.data(using: String.Encoding.utf8) {
            do {
              return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
              print(error)
            }
          }
          return nil
    }
    
    public func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
    
    func objectMaybeExist(buckId: String, buckName: String, objectId: String, ossContext: IMContext) -> Promise<Bool> {
        return IMGetAwsObjectExists.execute(bucketID: buckId, key: objectId, nf: ossContext.netFactory)
    }
    
    /*
    func objectMaybeExist(buckId: String, buckName: String, objectId: String) -> Promise<Bool> {
        let promise = Promise<Bool> { (resolve, reject) in
            
            let aWSS3Server = AWSS3.default()
            let objectRequest = AWSS3HeadObjectRequest()!
            objectRequest.bucket = buckName
            objectRequest.key = objectId

            aWSS3Server.headObject(objectRequest) { output, error in
                var isHave: Bool = false
                let contentLength: Int = output?.contentLength?.intValue ?? 0
                if contentLength > 0 {
                    isHave = true
                }
                resolve(isHave)
            }
        }
        return promise
    }
     */

}

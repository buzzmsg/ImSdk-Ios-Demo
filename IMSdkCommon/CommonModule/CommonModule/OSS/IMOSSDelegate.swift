//
//  IMOSSDelegate.swift
//  CommonModule
//
//  Created by Joey on 2023/5/10.
//

import Foundation

public protocol IMOSSDelegate : NSObjectProtocol {
    
    func getSelfBucketId() -> Promise<String>
    func getSelfBucket() -> Promise<IMStartBucketModel?>
    func bucketInfo(bucketID: String) -> Promise<IMBucketInfoModel>
    func objectMaybeExist(buckId: String, buckName: String, objectId: String) -> Promise<Bool>
    func getFinalBucketInfo() -> Promise<IMBucketInfoModel>
    
    func updateFileBusinessFailed(objectId: String, progress: Int)
    func updateFileBusinessSuccess(objectId: String)
    
}



class IMOSSBaseDelegate: NSObject, IMOSSDelegate {
    
    
    func getSelfBucketId() -> Promise<String> {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
        return Promise<String>.resolve("")
    }
    func getSelfBucket() -> Promise<IMStartBucketModel?> {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
        return Promise<IMStartBucketModel?>.resolve(nil)
    }
    func bucketInfo(bucketID: String) -> Promise<IMBucketInfoModel> {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
        return Promise<IMBucketInfoModel>.resolve(IMBucketInfoModel())
    }
    func objectMaybeExist(buckId: String, buckName: String, objectId: String) -> Promise<Bool> {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
        return Promise<Bool>.resolve(true)
    }
    func getFinalBucketInfo() -> Promise<IMBucketInfoModel> {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
        return Promise<IMBucketInfoModel>.resolve(IMBucketInfoModel())
    }
    
    func updateFileBusinessFailed(objectId: String, progress: Int) {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
    }
    func updateFileBusinessSuccess(objectId: String) {
        SDKDebugLog("[\(self)] [\(#function)] IMOSSDelegate is not set, plaese set delegate !!")
    }
    
}

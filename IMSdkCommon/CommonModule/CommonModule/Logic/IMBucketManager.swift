//
//  IMBucketManager.swift
//  TMM
//
//  Created by on 2021/8/6.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation

let key_bucket_id: String = "key_bucket_id"
let key_bucket_id_accelerate: String = "key_bucket_id_accelerate"

let provider_aws: String = "aws"
let provider_ali: String = "ali"


public typealias  GetBucketInfoClosure = (((IMBucketInfoModel) -> Void),  ((Error) -> Void))
/*
 "bucketid1": [some getBucketInfo cloasure]
 "bucketid2": [some getBucketInfo cloasure]
 */
public var getBucketInfoClosures: [String: [GetBucketInfoClosure]] = [:]

public struct IMBucketManager {

    static public func initBucket(nf: IMNetFactory) {
       let _ = IMStartBucketApi.execute(nf: nf)
    }

    public init() {

    }
    
    public func getSelfBucket(context: IMContext) -> Promise<IMStartBucketModel?> {

        guard let dataBase = context.shareDB else {
            dbErrorLog("[\(#function)]: context db is nil")
            return Promise<IMStartBucketModel?>.reject(IMNetworkingError.createCommonError())
        }
        
        var bucketId = ""
        var is_accelerate = false

        let generalDao: IMUserValueDao = IMUserValueDao(shareDB: dataBase)
        if let gModel = generalDao.queryGeneralModel(keyword: key_bucket_id) {
            bucketId = gModel.val
        }
  
        if let gModel = generalDao.queryGeneralModel(keyword: key_bucket_id_accelerate) {
            is_accelerate = gModel.val == "1"
        }
        
        
        if bucketId.count > 0 {
            let startBucketModel = IMStartBucketModel(bucket_id: bucketId, is_accelerate: is_accelerate)
            return Promise<IMStartBucketModel?>.resolve(startBucketModel)
        }

        return IMStartBucketApi.execute(nf: context.netFactory)
            .then { value -> Promise<IMStartBucketModel?> in

                guard let bucket = value else {
                    return Promise<IMStartBucketModel?>.resolve(nil)
                }
                
                var bucketModel: IMStartBucketModel = IMStartBucketModel()
                bucketModel.bucket_id = bucket.bucket_id
                bucketModel.is_accelerate = bucket.is_accelerate
                
                
                generalDao.insertGeneralModel(keyword: key_bucket_id, val: bucket.bucket_id ?? "")
                var isAsss: String = "1"
                if bucket.is_accelerate == false {
                    isAsss = "0"
                }
                generalDao.insertGeneralModel(keyword: key_bucket_id_accelerate, val: isAsss)

                return Promise<IMStartBucketModel?>.resolve(bucketModel)
            }
    }
    
    public func getSelfBucketId(context: IMContext) -> Promise<String> {
        return getSelfBucket(context: context).then { bucket -> Promise<String> in

            var bucketId: String = ""
            if bucket == nil || bucket?.bucket_id == nil || bucket?.bucket_id?.isEmpty == true {
                bucketId = ""
            }else {
                bucketId = bucket?.bucket_id ?? ""
            }
            return Promise<String>.resolve(bucketId)
        }
    }
    
    public func getBucketInfo(bucketID: String, context: IMContext) -> Promise<IMBucketInfoModel> {
        
        guard let dataBase = context.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return Promise<IMBucketInfoModel>.reject(IMNetworkingError.createCommonError())
        }
        
        let nowTime: Int = Date().milliStamp
        
        /*
         Refresh bucket info of time when it expires in 5 minutes
         300000ms = 5m * 60s * 1000ms
         */
         
        let expireTime: Int = 300000
        
        let bucketDao: IMBucketDao = IMBucketDao(db: dataBase)
        if let bucket = bucketDao.getBucketInfo(bucketID: bucketID), let exp: Int =  bucket.expire {
            
            if exp - nowTime > expireTime {
                return Promise<IMBucketInfoModel>.resolve(bucket)
            }
            
        }
        

        
        let pro: Promise<IMBucketInfoModel> = Promise<IMBucketInfoModel>.init { (res, rej) in
            
            let closureTup: GetBucketInfoClosure = (res, rej)
            
            if var clsoureAry: [GetBucketInfoClosure] = getBucketInfoClosures[bucketID] {
                
                clsoureAry.append(closureTup)
                getBucketInfoClosures[bucketID] = clsoureAry
                return
            }
            
            self.goGetBucketInfo(bucketID: bucketID, context: context, resovl: closureTup)
            
        }
        
        return pro
    }
    
    
    private func  goGetBucketInfo(bucketID: String, context: IMContext, resovl: GetBucketInfoClosure) {
        
        guard let dataBase = context.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return
        }
        
        let bucketDao: IMBucketDao = IMBucketDao(db: dataBase)
        
        getBucketInfoClosures[bucketID] = [resovl]
        
        IMBucketInfo.execute(bucketID: bucketID, nf: context.netFactory)
            .then { value -> Promise<IMBucketInfoModel> in
                
                
                guard let bucket = value, bucket.bucketId != nil else {
                    let error = IMNetworkingError.createCommonError()
                    self.handleGetBucketInfoError(bucketID: bucketID, error: error)
                    
                    return Promise.reject(IMNetworkingError.createCommonError())
                }
                
                
                let jsonStr = bucket.toJSONString()
                if let bucketInfo = IMBucketInfoModel.deserialize(from: jsonStr) {
                    bucketInfo.sts = bucket.sts?.yh_jsonEnCode
                    bucketDao.saveBucketInfo(bucketInfo: bucketInfo)
                    
                    self.handleGetBucketInfoSuccess(bucketID: bucketID, info: bucketInfo)
                    return Promise<IMBucketInfoModel>.resolve(bucketInfo)
                }
                
                let error = IMNetworkingError.createCommonError()
                self.handleGetBucketInfoError(bucketID: bucketID, error: error)
                
                return Promise.reject(IMNetworkingError.createCommonError())
                
            }.catch { error in
                self.handleGetBucketInfoError(bucketID: bucketID, error: error)
                return Promise.reject(IMNetworkingError.createCommonError())
            }
    }

    private func handleGetBucketInfoSuccess(bucketID: String, info: IMBucketInfoModel) {
        if let clsoureAry: [GetBucketInfoClosure] = getBucketInfoClosures[bucketID] {

            clsoureAry.forEach { (res, rej) in
               res(info)
            }
            getBucketInfoClosures.removeValue(forKey: bucketID)
        }
    }
    
    private func handleGetBucketInfoError(bucketID: String, error: Error) {
       
        if let clsoureAry: [GetBucketInfoClosure] = getBucketInfoClosures[bucketID] {

            clsoureAry.forEach { (res, rej) in
                rej(error)
            }
            getBucketInfoClosures.removeValue(forKey: bucketID)
        }
    }
    
    // MARK: -

    public func getFinalBucketInfo(context: IMContext) -> Promise<IMBucketInfoModel> {

        IMBucketManager().getSelfBucket(context: context).then { (value) -> Promise<String> in

            if value == nil || value?.bucket_id == nil || value?.bucket_id?.isEmpty == true {
                return Promise<String>.reject(IMNetworkingError.init(code: 1, desc: ""))
            }
            return Promise<String>.resolve(value?.bucket_id ?? "")

        }.then { (bucketId) -> Promise<IMBucketInfoModel> in
            IMBucketManager().getBucketInfo(bucketID: bucketId, context: context).then {(bucketInfo) -> Promise<IMBucketInfoModel> in
                if bucketInfo.bucketId == nil || bucketInfo.bucketId?.isEmpty == true {
                    return Promise.reject(IMNetworkingError.createCommonError())
                }
                return Promise<IMBucketInfoModel>.resolve(bucketInfo)
            }
        }
    }
}

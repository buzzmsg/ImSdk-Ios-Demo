//
//  IMBucketDao.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation
import WCDBSwift

private let TM_SELF_BUCKET_TABLE_NAME = "TM_SELF_BUCKET_TABLE"
private let TM_BUCKET_INFO_TABLE_NAME = "TM_BUCKET_INFO_TABLE"

public class IMBucketDao {
    
    
    private var db: Database
    public init(db: Database) {
        self.db = db
    }
    
    public func createTable() {
        
//        try? self.db.create(table: TM_SELF_BUCKET_TABLE_NAME, of: StartBucketModel.self)
        try? self.db.create(table: TM_BUCKET_INFO_TABLE_NAME, of: IMBucketInfoModel.self)

    }
    
    // MARK: - Self Bucket

    func saveSelfBucket(bucket: IMStartBucketModel) {
        try? self.db.insertOrReplace(objects: bucket, intoTable: TM_SELF_BUCKET_TABLE_NAME)
    }
    
    func getSelfBucket() -> IMStartBucketModel? {
        let result: IMStartBucketModel? = try? self.db.getObject(fromTable: TM_SELF_BUCKET_TABLE_NAME)
        return result
    }
    
    // MARK: - Bucket Info

    func saveBucketInfo(bucketInfo: IMBucketInfoModel) {
        try? self.db.insertOrReplace(objects: bucketInfo, intoTable: TM_BUCKET_INFO_TABLE_NAME)
    }
    
    func getBucketInfo(bucketID: String) -> IMBucketInfoModel? {
        let result: IMBucketInfoModel? = try? self.db.getObject(fromTable: TM_BUCKET_INFO_TABLE_NAME, where: IMBucketInfoModel.Properties.bucketId == bucketID)
        return result
    }
}

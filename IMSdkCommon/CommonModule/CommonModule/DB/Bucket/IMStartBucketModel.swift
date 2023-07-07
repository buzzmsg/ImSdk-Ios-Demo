//
//  IMStartBucketModel.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation
import HandyJSON
import WCDBSwift

public struct IMStartBucketModel: TableCodable, HandyJSON {
    public init() {
        
    }
    
    public var bucket_id: String?
//    var s3_bucket: String?
//    var s3_region: String?
    public var is_accelerate: Bool = false
    
    mutating public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.bucket_id <-- "s3_bucket_id"

    }
    
    public init(bucket_id: String?, is_accelerate: Bool) {
        self.bucket_id = bucket_id
        self.is_accelerate = is_accelerate
    }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = IMStartBucketModel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case bucket_id
//        case s3_bucket
//        case s3_region
        case is_accelerate

        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .bucket_id: ColumnConstraintBinding(isPrimary: true, defaultTo: ""),
//                .s3_bucket: ColumnConstraintBinding(defaultTo: ""),
//                .s3_region: ColumnConstraintBinding(defaultTo: ""),
                .is_accelerate: ColumnConstraintBinding(defaultTo: false)
            ]
        }
    }
}

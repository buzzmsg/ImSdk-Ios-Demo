//
//  IMBucketInfoModel.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation
import WCDBSwift
import HandyJSON

public class IMBucketInfoModel: TableCodable, HandyJSON {
    public var bucketId: String?
    public var bucketName: String?
    public var baseHost: String?
    public var region: String?
    public var cropHost: String?
    public var sts: String?
    public var expire: Int?
    public var provider: String?
    public var accelerateHost: String?

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = IMBucketInfoModel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case bucketId
        case bucketName
        case baseHost
        case region
        case cropHost
        case sts
        case expire
        case provider
        case accelerateHost

        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .bucketId: ColumnConstraintBinding(isPrimary: true, isNotNull: true),
                .bucketName: ColumnConstraintBinding(defaultTo: ""),
                .baseHost: ColumnConstraintBinding(defaultTo: ""),
                .region: ColumnConstraintBinding(defaultTo: ""),
                .cropHost: ColumnConstraintBinding(defaultTo: ""),
                .sts: ColumnConstraintBinding(defaultTo: ""),
                .expire: ColumnConstraintBinding(defaultTo: ""),
                .provider: ColumnConstraintBinding(defaultTo: ""),
                .accelerateHost: ColumnConstraintBinding(defaultTo: ""),
            ]
        }
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.baseHost <-- "base_host"
        
        mapper <<<
            self.cropHost <-- "crop_host"
        
        mapper <<<
            self.bucketId <-- "bucket_id"
        
        mapper <<<
            self.bucketName <-- "bucket_name"
    }
    
    required public init() {}
}

//
//  IMFileProgressModel.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation
import WCDBSwift
import HandyJSON

@objc public enum IMTransferProgressState: Int {
    
    // -99~-1 downloading failure
    case failureMin = -100 // TODO: will delete
    // 0~99 downloading...
    case fileNotExist = 404
    
    case start = 0
    case success = 100
    case notDown = 400
    case wait = 600
    //8XX Hundreds indicate pause，The last two digits represent the progress value
    case pausedMin = 700
    //8XX Hundreds indicate failure，The last two digits represent the progress value
    case failedMin = 800
    
}
@objc public enum IMTransferFileSizeType: Int {
    case small = 1
    case big = 2
}


@objc public enum IMTransferSence: Int {
    case IM = 1
    case moments = 2
}

@objc public enum IMFileDownloadPermissionType: Int {
    case none = 0
    case all = 1
}

let kRetryDownloadMaxCount: Int = 3
struct IMFileProgressModel : TableCodable, HandyJSON ,Hashable {
    
    var objectId : String = ""
    var progress: Int = IMTransferProgressState.wait.rawValue
    var bucketId  : String = ""
    var createTime: Int = 0
    var sourceSence: Int = 2
    var isNeedNotice: Int = 0
    var sizeType: Int = IMTransferFileSizeType.small.rawValue
    var retryCount: Int = 0
    var permissionType: Int = IMFileDownloadPermissionType.none.rawValue

    enum CodingKeys: String, CodingTableKey {
        typealias Root = IMFileProgressModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case objectId
        case progress
        case bucketId
        case createTime
        case sourceSence
        case isNeedNotice
        case sizeType
        case retryCount
        case permissionType

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                objectId: ColumnConstraintBinding(isPrimary: true),
                progress: ColumnConstraintBinding(defaultTo: 0),
                createTime: ColumnConstraintBinding(defaultTo: 0),
                bucketId: ColumnConstraintBinding(defaultTo: ""),
                sourceSence: ColumnConstraintBinding(defaultTo: 0),
                isNeedNotice: ColumnConstraintBinding(defaultTo: 0),
                sizeType: ColumnConstraintBinding(defaultTo: 0),
                retryCount: ColumnConstraintBinding(defaultTo: 0),
                permissionType: ColumnConstraintBinding(defaultTo: 0),
            ]
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(objectId)
    }
    
    
    static func == (lhs: IMFileProgressModel, rhs: IMFileProgressModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

//
//  IMShareUserModel.swift
//  SDK
//
//  Created by Joey on 2022/10/8.
//

import Foundation
import WCDBSwift
import HandyJSON

public class IMShareUserModel: TableCodable, HandyJSON, Hashable {
    

    public var aUid: String = ""
    public var userId: String = ""
    

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = IMShareUserModel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case aUid
        case userId

        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                aUid: ColumnConstraintBinding(isPrimary: true),
                userId: ColumnConstraintBinding(isUnique: true),
            ]
        }
        
    }
    
    required public init() {
        
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.userId)
    }
    
    public static func == (lhs: IMShareUserModel, rhs: IMShareUserModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

//
//  IMUserValueModel.swift
//  IMSDK
//
//  Created by 公爵 on 2022/11/30.
//

import Foundation
import WCDBSwift
import HandyJSON

public class IMUserValueModel: TableCodable, HandyJSON, Hashable {
    
    public var keyword: String = ""
    public var val: String = ""
    
    
    

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = IMUserValueModel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case keyword
        case val

        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                keyword: ColumnConstraintBinding(isPrimary: true),
                val: ColumnConstraintBinding(defaultTo: ""),
            ]
        }
        
    }
    
    required public init() {
        
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.keyword)
    }
    
    public static func == (lhs: IMUserValueModel, rhs: IMUserValueModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

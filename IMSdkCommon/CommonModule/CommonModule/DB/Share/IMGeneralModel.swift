//
//  IMGeneralModel.swift
//  TMM
//
//  Created by Joey on 2022/11/16.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift
import HandyJSON

class IMGeneralModel: TableCodable, HandyJSON, Hashable {
    
    var keyword: String = ""
    var val: String = ""
    
    
    

    enum CodingKeys: String, CodingTableKey {
        typealias Root = IMGeneralModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case keyword
        case val

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                keyword: ColumnConstraintBinding(isPrimary: true),
                val: ColumnConstraintBinding(defaultTo: ""),
            ]
        }
        
    }
    
    required init() {
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.keyword)
    }
    
    static func == (lhs: IMGeneralModel, rhs: IMGeneralModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

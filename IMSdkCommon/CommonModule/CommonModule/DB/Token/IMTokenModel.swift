//
//  IMTokenModel.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation
import WCDBSwift

struct IMTokenModel: TableCodable {
    var baseUrl: String?
    var token: String?
    var host: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = IMTokenModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case token
        case baseUrl
        case host

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .baseUrl: ColumnConstraintBinding(isPrimary: true),
                .token: ColumnConstraintBinding(defaultTo: ""),
                host: ColumnConstraintBinding(defaultTo: "")
            ]
        }
    }
    
    init(with serviceName: String, tokenStr: String, host: String) {
        self.baseUrl = serviceName
        self.token = tokenStr
        self.host = host
    }
    
    init(with serviceName: String, tokenStr: String) {
        self.baseUrl = serviceName
        self.token = tokenStr
    }
}


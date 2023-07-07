//
//  IMGeneralDao.swift
//  TMM
//
//  Created by Joey on 2022/11/16.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift

private let IM_GENERAL_TABLE_NAME = "GENERAL_TABLE"
public struct IMGeneralDao {
    
    private var shareDB: Database
    
    public init(shareDB: Database) {
        self.shareDB = shareDB
    }
    
    @discardableResult
    public func createTable() -> Promise<Void> {
        
        do {
            try self.shareDB.create(table: IM_GENERAL_TABLE_NAME, of: IMGeneralModel.self)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    @discardableResult
    func insertGeneralModel(model: IMGeneralModel) -> Promise<Void> {
        
        do {
            try self.shareDB.insertOrReplace(objects: model, intoTable: IM_GENERAL_TABLE_NAME)
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }
        
    }
    
    func queryGeneralModel(keyword: String) -> IMGeneralModel? {
        do {
            let condition : Condition = IMGeneralModel.Properties.keyword == keyword
            let result: [IMGeneralModel] = try self.shareDB.getObjects(fromTable: IM_GENERAL_TABLE_NAME, where: condition)
            return result.first
        } catch {
            return nil
        }
    }
    
}

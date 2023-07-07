//
//  IMShareUserDao.swift
//  SDK
//
//  Created by Joey on 2022/10/8.
//

import Foundation
import WCDBSwift

private let TM_SHAREUSER_DATABASE_TABLE_NAME = "SHARE_USER_TABLE"

public struct IMShareUserDao {
    
    private var shareDB: Database
//    init() {
//        self.init(shareDB: TMDatabaseUtil.default.shareBase!)
//    }
    
    public init(shareDB: Database) {
        self.shareDB = shareDB
    }
    
//    static var `default` = IMShareUserDao()
    
    @discardableResult
    public func createTable() -> Promise<Void> {
        
        do {
            try self.shareDB.create(table: TM_SHAREUSER_DATABASE_TABLE_NAME, of: IMShareUserModel.self)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    // MARK: -
    
    func insertShareUserModel(model: IMShareUserModel) -> Promise<Void> {
        
        do {
            try self.shareDB.run(transaction: {
                try self.shareDB.delete(fromTable: TM_SHAREUSER_DATABASE_TABLE_NAME)
                try self.shareDB.insertOrReplace(objects: model, intoTable: TM_SHAREUSER_DATABASE_TABLE_NAME)
            })
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }
        
    }
    
    func queryShareUserModels() -> [IMShareUserModel] {
        
        do {
            let result: [IMShareUserModel] = try self.shareDB.getObjects(fromTable: TM_SHAREUSER_DATABASE_TABLE_NAME)
            return result
        } catch {
            return []
        }
        
    }
    
    
    func queryShareUserModel(aUid: String) -> IMShareUserModel? {
        do {
            let condition : Condition = IMShareUserModel.Properties.aUid == aUid
            let result: [IMShareUserModel] = try self.shareDB.getObjects(fromTable: TM_SHAREUSER_DATABASE_TABLE_NAME, where: condition)
            return result.first
        } catch {
            return nil
        }
    }
    
    func clearShareUser() -> Promise<Void> {
        do {
            try self.shareDB.delete(fromTable: TM_SHAREUSER_DATABASE_TABLE_NAME)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
}

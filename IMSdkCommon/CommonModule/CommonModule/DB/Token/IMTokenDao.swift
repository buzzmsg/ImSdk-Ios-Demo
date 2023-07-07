//
//  IMTokenDao.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation
import WCDBSwift

private let TM_USER_TOKEN_TABLE_NAME = "TM_USER_TOKEN_TABLE"

public struct IMTokenDao {
        
    private var db: Database
    public init(db: Database) {
        self.db = db
    }
    
    @discardableResult
    public func createTable() -> Promise<Void> {
        
        do {
            try self.db.create(table: TM_USER_TOKEN_TABLE_NAME, of: IMTokenModel.self)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func getTokenByName(name: String) -> Promise<IMTokenModel?> {

        do {
            let result: IMTokenModel? = try self.db.getObject(fromTable: TM_USER_TOKEN_TABLE_NAME,
                                                             where: IMTokenModel.Properties.baseUrl == name)
            return Promise<IMTokenModel?>.resolve(result)

        } catch {
            let logStr = "sdk get token from DB catch error \(error)"
            SDKDebugLog( logStr)
            return Promise<IMTokenModel?>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func insertToken(token: IMTokenModel) -> Promise<Void> {

        guard let _ = token.baseUrl else {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        do {
            try self.db.insertOrReplace(objects: token, intoTable: TM_USER_TOKEN_TABLE_NAME)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func updateToken(token: IMTokenModel) -> Promise<Void> {

        guard let name = token.baseUrl else {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
        
        do {
            try self.db.update(table: TM_USER_TOKEN_TABLE_NAME,
                                on: IMTokenModel.Properties.token,
                                with: token,
                                where: IMTokenModel.Properties.baseUrl == name)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    public func cleanToken(name: String) -> Promise<Void> {
        
        do {
            try self.db.delete(fromTable: TM_USER_TOKEN_TABLE_NAME, where: IMTokenModel.Properties.baseUrl == name)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
}

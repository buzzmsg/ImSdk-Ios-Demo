//
//  IMUserValueDao.swift
//  IMSDK
//
//  Created by 公爵 on 2022/11/30.
//

import Foundation
import WCDBSwift

private let IM_GENERAL_TABLE_NAME = "NORMAL_VALUE_TABLE"
public struct IMUserValueDao {
    
    private var shareDB: Database
    
    public init(shareDB: Database) {
        self.shareDB = shareDB
    }
    
    @discardableResult
    public func createTable() -> Promise<Void> {
        
        do {
            try self.shareDB.create(table: IM_GENERAL_TABLE_NAME, of: IMUserValueModel.self)
            return Promise<Void>.resolve()

        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    @discardableResult
    func insertGeneralModel(model: IMUserValueModel) -> Promise<Void> {

        if model.keyword.isEmpty {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
        
        let uid = IMShareLogic(shareDB).getLoginUid()
        if uid.isEmpty {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
        
        model.keyword = self.getHandleKeyword(keyword: model.keyword) 
        
        do {
            try self.shareDB.insertOrReplace(objects: model, intoTable: IM_GENERAL_TABLE_NAME)
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }

    }
    
    
    @discardableResult
    public func insertGeneralModel(keyword: String, val: String) -> Bool {

        if keyword.isEmpty {
            return false
        }
        
        let model: IMUserValueModel = IMUserValueModel()
        model.keyword = self.getHandleKeyword(keyword: keyword)
        model.val = val
        
        do {
            try self.shareDB.insertOrReplace(objects: model, intoTable: IM_GENERAL_TABLE_NAME)
            return true
        } catch {
            return false
        }
    }
    
    
    public func queryGeneralModel(keyword: String) -> IMUserValueModel? {
        do {
            
            let trueKeyword: String = self.getHandleKeyword(keyword: keyword)
            let condition : Condition = IMUserValueModel.Properties.keyword == trueKeyword
            let result: [IMUserValueModel] = try self.shareDB.getObjects(fromTable: IM_GENERAL_TABLE_NAME, where: condition)
            return result.first
        } catch {
            return nil
        }
    }
    
    
    private func getHandleKeyword(keyword: String) -> String {
        
        let uid = IMShareLogic(shareDB).getLoginUid()
        if uid.isEmpty {
            return keyword
        }
        
        return uid + "_" + keyword
    }
}

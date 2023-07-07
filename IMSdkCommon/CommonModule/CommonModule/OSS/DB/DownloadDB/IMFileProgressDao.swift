//
//  TmFileStatusDao.swift
//  TMM
//
//  Created by    on 2022/5/17.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift

private let TM_FILE_STATUS_TABLE_NAEM = "TM_FILE_STATUS_TABLE_NAME"

let kMinTime: Int = 1487659853000

public struct IMFileProgressDao {
    
    public func createTable() {
        try? self.db.create(table: TM_FILE_STATUS_TABLE_NAEM, of: IMFileProgressModel.self)
    }
    
    private(set) var db: Database
    
    public init(db: Database) {
        self.db = db
    }
    
    
    //MARk: start
    
    func querySmallFileWaitProgress(count: Int) -> Promise<[IMFileProgressModel]> {
        do {
            var result: [IMFileProgressModel] = []
            try self.db.run(transaction: {
                let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue && IMFileProgressModel.Properties.sizeType == IMTransferFileSizeType.small.rawValue
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                let smallFileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition, orderBy: [order], limit: count)
                
                var objectIds: [String] = []
                for tModel in smallFileResult {
                    let p = IMConfigManager.default.getOssProgress(progress: tModel.progress)
                    let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.progress.rawValue)
                    var fileProgressEntity = IMFileProgressModel()
                    fileProgressEntity.progress = lp
                    objectIds.append(tModel.objectId)
                    try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == tModel.objectId)
                }
                
                let progResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds), orderBy: [order])
                result.append(contentsOf: progResult)
            })
            return Promise<[IMFileProgressModel]>.resolve(result)
        } catch {
            return Promise<[IMFileProgressModel]>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func queryBigFileWaitProgress(count: Int) -> Promise<[IMFileProgressModel]> {
        do {
            var result: [IMFileProgressModel] = []
            try self.db.run(transaction: {
                let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue && IMFileProgressModel.Properties.sizeType == IMTransferFileSizeType.big.rawValue
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                let bigFileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition, orderBy: [order], limit: count)
                
                var objectIds: [String] = []
                for tModel in bigFileResult {
                    let p = IMConfigManager.default.getOssProgress(progress: tModel.progress)
                    let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.progress.rawValue)
                    var fileProgressEntity = IMFileProgressModel()
                    fileProgressEntity.progress = lp
                    objectIds.append(tModel.objectId)
                    try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == tModel.objectId)
                }
                
                let progResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds), orderBy: [order])
                result.append(contentsOf: progResult)
            })
            return Promise<[IMFileProgressModel]>.resolve(result)
        } catch {
            return Promise<[IMFileProgressModel]>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func queryBigFilePriorityWaitProgress(count: Int) -> Promise<[IMFileProgressModel]> {
        
        do {
            var result: [IMFileProgressModel] = []
            try self.db.run(transaction: {
                let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue && IMFileProgressModel.Properties.sizeType == IMTransferFileSizeType.big.rawValue
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                var bigFileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition, orderBy: [order], limit: count)
                
                let diff: Int = (count - bigFileResult.count)
                if diff > 0 {
                    let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue && IMFileProgressModel.Properties.sizeType == IMTransferFileSizeType.small.rawValue
                    let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                    let smallFileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition, orderBy: [order], limit: diff)
                    if smallFileResult.count != 0 {
                        bigFileResult.append(contentsOf: smallFileResult)
                    }
                }
                
                var objectIds: [String] = []
                for tModel in bigFileResult {
                    let p = IMConfigManager.default.getOssProgress(progress: tModel.progress)
                    let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.progress.rawValue)
                    var fileProgressEntity = IMFileProgressModel()
                    fileProgressEntity.progress = lp
                    objectIds.append(tModel.objectId)
                    try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == tModel.objectId)
                }
                
                let fileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds), orderBy: [order])
                result.append(contentsOf: fileResult)
            })
            return Promise<[IMFileProgressModel]>.resolve(result)
        } catch {
            return Promise<[IMFileProgressModel]>.reject(error)
        }
        
    }
    
    
    
    //MARK end
    
    // MARK: - Insert
    func insertFileStatusEntities(fileStatusEntities: [IMFileProgressModel]?) -> Promise<Void> {

        guard let msgs = fileStatusEntities, msgs.count > 0 else {
            return Promise<Void>.resolve()
        }
        
        do {
            try self.db.insert(objects: msgs, intoTable: TM_FILE_STATUS_TABLE_NAEM)
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    public func updatePermissionType(objectId:String ,permissionType: Int) -> Promise<Void> {
        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
        
        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.permissionType = permissionType
        
        do {
            
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.permissionType, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    // MARK:- update
    public func updateProgress(objectId: String, progress: Int) -> Promise<Void> {
        

        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress

        do {
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId && IMFileProgressModel.Properties.progress <= progress)
            })
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }

    func updateProgressOnStart(objectId: String, progress: Int) -> Promise<Void> {

        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress

        
        do {
            
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    func updateProgressStart(objectIds: [String], progress: Int) -> Promise<Void> {
        

        if objectIds.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress

        do {
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId.in(objectIds))
            })
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    func updateProgress(objectId: String, progress: Int, timeStamp: Int? = nil, retryCount: Int? = nil) -> Promise<Void> {
        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress
        var updateColumn = [IMFileProgressModel.Properties.progress]
        if let timeVal = timeStamp {
            fileProgressEntity.createTime = timeVal
            updateColumn.append(IMFileProgressModel.Properties.createTime)
        }
        if let countVal = retryCount {
            fileProgressEntity.retryCount = countVal
            updateColumn.append(IMFileProgressModel.Properties.retryCount)
        }
        do {
            
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: updateColumn, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    func updateProgressOnError(objectId: String, progress: Int) -> Promise<Void> {
        

        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress

        do {
            try self.db.run(transaction: {
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    public func updateProgressCreateTime(objectId: String, time: Int) -> Promise<Void> {
        

        if objectId.count == 0 {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.createTime = time

        do {
            try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.createTime, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            return Promise<Void>.resolve()
        } catch  {
            return Promise<Void>.reject(error)
        }
    }
    
    func updateProgressOnWaitToOrderLast(objectId: String, progress: Int, retryCount: Int? = nil) -> Promise<Void> {
        do {
            try self.db.run(transaction: {
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .ascending)
                let results: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, orderBy: [order], limit: 1)
                
                var time: Int = kMinTime
                if let tModel = results.first {
                    time = tModel.createTime - 100
                }
                
                var fileProgressEntity = IMFileProgressModel()
                fileProgressEntity.progress = progress
                fileProgressEntity.createTime = time
                var updateColumn = [IMFileProgressModel.Properties.progress, IMFileProgressModel.Properties.createTime]
                if let countVal = retryCount {
                    fileProgressEntity.retryCount = countVal
                    updateColumn.append(IMFileProgressModel.Properties.retryCount)
                }
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: updateColumn, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }
    }
    
    func updateProgressOnWaitToOrderFirst(objectId: String, progress: Int, retryCount: Int? = nil) -> Promise<Void> {
        do {
            try self.db.run(transaction: {
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                let results: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, orderBy: [order], limit: 1)
                
                var time: Int = Date().milliStamp
                if let tModel = results.first {
                    time = tModel.createTime + 100
                }
                
                var fileProgressEntity = IMFileProgressModel()
                fileProgressEntity.progress = progress
                fileProgressEntity.createTime = time
                var updateColumn = [IMFileProgressModel.Properties.progress, IMFileProgressModel.Properties.createTime]
                if let countVal = retryCount {
                    fileProgressEntity.retryCount = countVal
                    updateColumn.append(IMFileProgressModel.Properties.retryCount)
                }
                try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: updateColumn, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId)
            })
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }
    }
    
    
    // MARK:- update -- (600)
    public func resetProgressWait() -> Promise<Void> {
        
        
        do {
            var model: IMFileProgressModel = IMFileProgressModel()
            model.progress = IMTransferProgressState.wait.rawValue
            try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: model)
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    
    func getWaitProgress(count: Int) -> Promise<[IMFileProgressModel]> {
        
        do {
            let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue
            let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
            let result: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition, orderBy: [order], limit: count)
            return Promise<[IMFileProgressModel]>.resolve(result)
        } catch {
            return Promise<[IMFileProgressModel]>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    @discardableResult
    func updateProgressWaitToOrderFirstForNetChange(objectIds: [String]) -> Promise<Void> {
        do {
            try self.db.run(transaction: {
                let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.progress.rawValue && IMFileProgressModel.Properties.permissionType != IMFileDownloadPermissionType.all.rawValue && IMFileProgressModel.Properties.sizeType == IMTransferFileSizeType.big.rawValue && IMFileProgressModel.Properties.objectId.in(objectIds)
                let bigFileResult: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition)
                
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .descending)
                let results: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.wait.rawValue, orderBy: [order])
                
                var time: Int = Date().milliStamp
                if let tModel = results.first {
                    time = tModel.createTime + 100
                }
                
                for tProg in bigFileResult {
                    let p = IMConfigManager.default.getOssProgress(progress: tProg.progress)
                    let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.wait.rawValue)
                    var fileProgressEntity = IMFileProgressModel()
                    fileProgressEntity.progress = lp
                    fileProgressEntity.createTime = time
                    
                    let updateColumn = [IMFileProgressModel.Properties.progress, IMFileProgressModel.Properties.createTime]
                    try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: updateColumn, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == tProg.objectId)
                }
                
            })
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(error)
        }
    }
    
    func removePregress(objectIds: [String]) -> Promise<Void> {
        

        if objectIds.count == 0 {
            return Promise<Void>.resolve()
        }
        
        do {
            let condition: Condition = IMFileProgressModel.Properties.objectId.in(objectIds)
            try self.db.delete(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition)
            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func queryProgress(objectId: String) -> IMFileProgressModel? {

        if objectId.count == 0 {
            return nil
        }

        let result: IMFileProgressModel? = try? self.db.getObject(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId == objectId)

        return result
    }

    func resetDownloadingProgressToWait() -> Promise<Void> {
        
        let condition: Condition = (IMFileProgressModel.Properties.progress / 100) == OssDownLoadStatusConstant.progress.rawValue
        do {
            
            try self.db.run(transaction: {
                let result: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition)
                
                for item in result {
                    let p = IMConfigManager.default.getOssProgress(progress: item.progress)
                    let lp = IMConfigManager.default.synthesisProgress(progress: p, status: OssDownLoadStatusConstant.wait.rawValue)
                    var fileProgressEntity = IMFileProgressModel()
                    fileProgressEntity.progress = lp
                    
                    try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == item.objectId)
                }
            })
            


            return Promise<Void>.resolve()
        } catch {
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    
    func deleteProgressBy(expirationTime: Int, status: [Int]) -> Promise<[String]> {
        
        let condition: Condition = (IMFileProgressModel.Properties.progress / 100).in(status) && IMFileProgressModel.Properties.createTime <= expirationTime
        do {
            
            var val: [String] = []
            try self.db.run(transaction: {
                let result: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition)
                let objectIds: [String] = result.map({$0.objectId})
                try self.db.delete(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds))
                val.append(contentsOf: objectIds)
            })
            return Promise<[String]>.resolve(val)
        } catch {
            return Promise<[String]>.reject(IMNetworkingError.createCommonError())
        }
        
    }
    
    func deleteProgressByStatus(status: [Int]) -> Promise<[String]> {
        let condition: Condition = (IMFileProgressModel.Properties.progress / 100).in(status)
        do {
            
            var val: [String] = []
            try self.db.run(transaction: {
                let result: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: condition)
                let objectIds: [String] = result.map({$0.objectId})
                try self.db.delete(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds))
                val.append(contentsOf: objectIds)
            })
            return Promise<[String]>.resolve(val)
        } catch {
            return Promise<[String]>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func queryWithObjectId(objectId: String) -> Promise<IMFileProgressModel?>  {

        if objectId.count == 0 {
            return Promise<IMFileProgressModel?>.reject(IMNetworkingError.createCommonError())
        }

        do {
            let result: IMFileProgressModel? = try self.db.getObject(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId == objectId)
            return Promise<IMFileProgressModel?>.resolve(result)
        } catch {
            return Promise<IMFileProgressModel?>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    public func queryisWifiWithObjectId(objectId: String) -> Promise<Int> {
        if objectId.count == 0 {
            return Promise<Int>.reject(IMNetworkingError.createCommonError())
        }

        do {
            let result: IMFileProgressModel? = try self.db.getObject(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId == objectId)
            
            if let r = result {
                return Promise<Int>.resolve(r.permissionType)
            }
            return Promise<Int>.resolve(0)
        } catch {
            return Promise<Int>.reject(IMNetworkingError.createCommonError())
        }
    }
    
    func queryProgressTimeAscendingOrder(objectIds: [String]) -> Promise<[IMFileProgressModel]> {
        do {
            
            var models: [IMFileProgressModel] = []
            try self.db.run(transaction: {
                let order: OrderBy = IMFileProgressModel.Properties.createTime.asOrder(by: .ascending)
                let results: [IMFileProgressModel] = try self.db.getObjects(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId.in(objectIds), orderBy: [order])
                models.append(contentsOf: results)
            })
            return Promise<[IMFileProgressModel]>.resolve(models)
        } catch  {
            return Promise<[IMFileProgressModel]>.reject(error)
        }
    }
    
    // MARK: -

    func queryProgressValueWithEvent(objectId: String) -> Int {

        do {
            let result: IMFileProgressModel? = try self.db.getObject(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId == objectId)
            if result == nil {
                return IMTransferProgressState.success.rawValue
            }

            return result!.progress
            
        } catch  {
            return IMTransferProgressState.success.rawValue
        }
    }
    
    public func queryProgressValueNormal(objectId: String) -> Int {

        
        do {
            let result: IMFileProgressModel? = try self.db.getObject(fromTable: TM_FILE_STATUS_TABLE_NAEM, where: IMFileProgressModel.Properties.objectId == objectId)
            if result == nil {
                return IMTransferProgressState.wait.rawValue
            }

            return result!.progress
            
        } catch  {
            return IMTransferProgressState.wait.rawValue
        }
    }
    
    
    func updateProgressNew(objectId: String, progress: Int, complete:((Bool) -> ())?) {


        if objectId.count == 0 {
            if let com = complete {
                com(false)
            }
            return
        }

        var fileProgressEntity = IMFileProgressModel()
        fileProgressEntity.progress = progress

        do {
            try self.db.update(table: TM_FILE_STATUS_TABLE_NAEM, on: IMFileProgressModel.Properties.progress, with: fileProgressEntity, where: IMFileProgressModel.Properties.objectId == objectId && IMFileProgressModel.Properties.progress <= progress)
            
            if let com = complete {
                com(true)
            }
            
        } catch  {
            if let com = complete {
                com(false)
            }
        }
    }
    
}

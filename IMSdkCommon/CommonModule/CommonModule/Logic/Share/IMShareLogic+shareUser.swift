//
//  IMShareLogic+shareUser.swift
//  TMM
//
//  Created by Joey on 2022/11/19.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation


public extension IMShareLogic {
    
    func getUidFromShareDB(aUid: String) -> String {
        guard let shareDB = shareDB else {
            dbErrorLog("[\(#function)]: context db is nil")
            return ""
        }

        let shareUserDao: IMShareUserDao = IMShareUserDao.init(shareDB: shareDB)
        if let userModel = shareUserDao.queryShareUserModel(aUid: aUid) {
            return userModel.userId
        }
        return ""
    }
    
    func saveLoginUser(uid: String, aUid: String) -> Promise<Void> {
        
        guard let shareDB = shareDB else {
            dbErrorLog("[\(#function)]: context db is nil")
            return Promise<Void>.reject(IMNetworkingError.createCommonError())
        }
        
        let user: IMShareUserModel = IMShareUserModel()
        user.userId = uid
        user.aUid = aUid
        
        let shareUserDao: IMShareUserDao = IMShareUserDao.init(shareDB: shareDB)
        return shareUserDao.insertShareUserModel(model: user)
    }
    
    func getLoginUser() -> IMShareUserModel {
        
        if let tempContext = context, let loginMe = tempContext.me as? IMShareUserModel {
            return loginMe
        }
        
        guard let shareDB = shareDB else {
            dbErrorLog("[\(#function)]: context db is nil")
            return IMShareUserModel()
        }
        
        let users: [IMShareUserModel] = IMShareUserDao(shareDB: shareDB).queryShareUserModels()
        if users.count != 0 {
            return users[0]
        }
        return IMShareUserModel()
    }
    
    func getAuidFromShareDB() -> String {
        let user: IMShareUserModel = self.getLoginUser()
        return user.aUid
    }
    
    func getLoginUid() -> String {
        let user: IMShareUserModel = self.getLoginUser()
        return user.userId
    }
    
    func deleteLoginUser() {
        guard let shareDB = shareDB else {
            dbErrorLog("[\(#function)]: context db is nil")
            return 
        }
        SDKDebugLog("deleteLoginUser from shareDB!!")
        let shareUserDao: IMShareUserDao = IMShareUserDao.init(shareDB: shareDB)
        let _ = shareUserDao.clearShareUser()
    }
    
}

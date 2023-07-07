//
//  CreatDB.swift
//  TMMIMSdk
//
//  Created by 蒋小丫 on 2022/11/22.
//

import Foundation
import WCDBSwift

let TM_USER_DATABASE_FLODER_NAME = "TMDatabase"

func getDocumentPath() -> String {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    guard let path = documentPath else {
        return ""
    }
    return path
}


func getAKPath(ak: String, env: String) -> String {
    let path = getDocumentPath()
    let dirPath = path + "/" + ak + "/" + env
    print("creat database path: \(dirPath)")
    return dirPath
}

public func getSDKUserDatabase(ak: String, userId: String, env: String) -> Database {
    let dbPath = getAKPath(ak: ak, env: env)
    let userDBPath = dbPath + "/" + userId + ".db"
    let database = Database(withPath: userDBPath)
    return database
}

public func getSDKShareDatabase(ak: String, env: String) -> Database {
    let dbPath = getAKPath(ak: ak, env:env)
    let shareDBPath = dbPath + "/" + "share.db"
    let database = Database(withPath: shareDBPath)
    return database
}

func getTmmUserDatabase(userId: String, dbPre: String) -> Database {
    let path = getDocumentPath()
    let userDBPath = path + "/" + TM_USER_DATABASE_FLODER_NAME + "/" + dbPre + userId + ".db"
    let database = Database(withPath: userDBPath)
    return database
}


public func dbErrorLog(_ logStr: String) {
    #if DEBUG
            SDKDebugLog(logStr)
//            fatalError(logStr)
    #else
            SDKDebugLog(logStr)
    #endif
}


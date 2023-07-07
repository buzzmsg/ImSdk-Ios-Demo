//
//  IMContext.swift
//  TMM
//
//  Created by Joey on 2022/11/9.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit
import WCDBSwift

@objcMembers public class IMContext: NSObject {
    
    
    static private var defaultInstance: IMContext?
    
    public static func defualt() -> IMContext {
        if defaultInstance == nil {
            defaultInstance = IMContext()
        }
        
        return defaultInstance!
    }
    
    
    public init(nc: IMNotificationCenter = IMNotificationCenter.defualt(), nf: IMNetFactory = IMNetFactory.default) {
        self.nc = nc
        self.netFactory = nf
        
        //TODO
        //        self.db = TMDatabaseTool.default.base
        //        self.shareDB = TMDatabaseTool.default.commonBase
    }
    
    public var db: Database?
    public var shareDB: Database?
    
    // FTS db
    public var userVirtuaBase: Database?
    
    
    public var nc: IMNotificationCenter
    public var netFactory: IMNetFactory
    public var me: Any?
    
    
    public func setDB(db: Database) {
        self.db = db
    }
    
    public func setShareDB(db: Database) {
        self.shareDB = db
    }
    
    
    public func setUserVirtuaDB(db: Database) {
        self.userVirtuaBase = db
    }
}


//readonly let default = new IMContext

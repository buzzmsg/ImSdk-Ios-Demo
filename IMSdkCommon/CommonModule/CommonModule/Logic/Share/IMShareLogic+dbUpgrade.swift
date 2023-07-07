//
//  IMShareLogic+dbUpgrade.swift
//  CommonModule
//
//  Created by Joey on 2023/3/3.
//

import Foundation


private let dbUpgradeKeyword: String = "dbUpgradeKeyword"
private let dbUpgradeValue: String = "db already upgrade"
// not TMMTMM db upgrade
public extension IMShareLogic {
    
    
    func saveUpgradeValue() {
        if let db = shareDB {
            
            let gModel: IMGeneralModel = IMGeneralModel()
            gModel.keyword = dbUpgradeKeyword
            gModel.val = dbUpgradeValue
            
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            generalDao.insertGeneralModel(model: gModel)
            return
        }
        dbErrorLog("[\(#function)]: context db is nil")
    }
    
    func getUpgradeValue() -> String {
        if let db = shareDB {
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            if let gModel = generalDao.queryGeneralModel(keyword: dbUpgradeKeyword) {
                return gModel.val
            }
            return ""
        }
        dbErrorLog("[\(#function)]: context db is nil")
        return ""
    }
    
    func haveBeenUpgrade() -> Bool {
                
        let value: String = getUpgradeValue()
        return (value == dbUpgradeValue)
    }
    
    
}

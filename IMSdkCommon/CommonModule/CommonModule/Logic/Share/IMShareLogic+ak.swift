//
//  IMShareLogic+ak.swift
//  TMM
//
//  Created by Joey on 2022/11/19.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

private let akKeyword: String = "ak"
public let TmmTmmAK: String = "TMMTMM"
public extension IMShareLogic {
    
    func saveAK(ak: String) {
        if let db = shareDB {
            
            let gModel: IMGeneralModel = IMGeneralModel()
            gModel.keyword = akKeyword
            gModel.val = ak
            
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            generalDao.insertGeneralModel(model: gModel)
            return
        }
        dbErrorLog("[\(#function)]: context db is nil")
    }
    
    func getAK() -> String {
        if let db = shareDB {
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            if let gModel = generalDao.queryGeneralModel(keyword: akKeyword) {
                return gModel.val
            }
            return ""
        }
        dbErrorLog("[\(#function)]: context db is nil")
        return ""
    }
    
    func isTmmAK() -> Bool {
                
        let ak: String = getAK()
        return (ak == TmmTmmAK)
    }
    
}

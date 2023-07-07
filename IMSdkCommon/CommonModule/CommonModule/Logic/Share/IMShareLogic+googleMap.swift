//
//  IMShareLogic+googleMap.swift
//  TMMIMSdk
//
//  Created by 蒋小丫 on 2022/11/24.
//

import Foundation

private let googleMapKeyword: String = "googleMapKey"

private let excludeKeyword: String = "excludeMapKey"

public extension IMShareLogic {
    func saveGoogleMapKey(mapKey: String) {
        
        if let db = shareDB {
            
            let gModel: IMGeneralModel = IMGeneralModel()
            gModel.keyword = googleMapKeyword
            gModel.val = mapKey
            
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            generalDao.insertGeneralModel(model: gModel)
            return
        }
        dbErrorLog("[\(#function)]: context db is nil")
    }
    
    func getGoogleMapKey() -> String {
        if let db = shareDB {
            let generalDao: IMGeneralDao = IMGeneralDao(shareDB: db)
            if let gModel = generalDao.queryGeneralModel(keyword: googleMapKeyword) {
                return gModel.val
            }
            return ""
        }
        dbErrorLog("[\(#function)]: context db is nil")
        return ""
    }
        
    func getExcludeChatIds(context: IMContext) -> [String] {
        guard let db = context.shareDB else {
            return []
        }
        
        let generalDao: IMUserValueDao = IMUserValueDao(shareDB: db)
        if let gModel = generalDao.queryGeneralModel(keyword: excludeKeyword) {
            let value = gModel.val
            if let jsonData = value.data(using: .utf8) , let array: [String] = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String] {
                return array
            }
            return []
        }
        
        return []
    }
    
    func saveExcludeChatIds(ids: [String],context: IMContext) {
        guard let db = context.shareDB else {
            return
        }
        let generalDao: IMUserValueDao = IMUserValueDao(shareDB: db)

        if ids.count == 0 {
            generalDao.insertGeneralModel(keyword: excludeKeyword, val: "")
            return
        }
        if !JSONSerialization.isValidJSONObject(ids) {
            print("解析失败了啊！")
        }
        
        let jsonData : Data! = try? JSONSerialization.data(withJSONObject: ids, options: [])
        if let ridsString = String(data:jsonData, encoding: .utf8) {
            generalDao.insertGeneralModel(keyword: excludeKeyword, val: ridsString)
        }
        return
    }
}


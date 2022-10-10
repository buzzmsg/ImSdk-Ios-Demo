//
//  TokenManager.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

class TMTokenManager  {
    
    private var cacheTokenMap = [String:String]()
    
    static let EMPTY_TOKEN = ""
    
    private static let instance = TMTokenManager()
    
    static func getInstance() -> TMTokenManager {
        return instance
    }
    
    
    // MARK: -
    
    func getTokenByServiceName(serviceName: String) -> Promise<String?> {
        if cacheTokenMap.keys.contains(serviceName) {
            return Promise<String?>.resolve(cacheTokenMap[serviceName])
        }
        return Promise<String?>.resolve(cacheTokenMap[serviceName])
        
//        return TMTokenDao.default.getTokenByName(name: serviceName)
//            .then { value -> Promise<String?> in
//                return Promise<String?>.resolve(value?.token)
//            }
    }
    
    func getHostByServiceName(serviceName: String) -> Promise<String?> {
//        return TMTokenDao.default.getTokenByName(name: serviceName)
//            .then { value -> Promise<String?> in
//                return Promise<String?>.resolve(value?.host)
//            }
        
        return Promise<String?>.resolve(cacheTokenMap[serviceName])
    }
    
    func insertNet(serviceName: String, token: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.updateValue(token, forKey: serviceName)
        }

//        let tokenModel = TMTokenModel(with: serviceName, tokenStr: token)
//        let _ = TMTokenDao.default.insertToken(token: tokenModel)
    }
    
    func updateToken(serviceName: String, token: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.updateValue(token, forKey: serviceName)
        }

//        let tokenModel = TMTokenModel(with:serviceName, tokenStr: token)
//        let _ = TMTokenDao.default.updateToken(token: tokenModel)
    }
    
    func clearTokenByServiceName(serviceName: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.removeValue(forKey: serviceName)
        }
//        let _ = TMTokenDao.default.cleanToken(name: serviceName)
    }
    
}

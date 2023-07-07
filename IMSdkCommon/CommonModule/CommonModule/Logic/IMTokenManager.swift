//
//  IMTokenManager.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

public class IMTokenManager  {
    
    private var cacheTokenMap = [String:String]()
    
    static let EMPTY_TOKEN = ""
    
    public var context: IMContext?
    init(context: IMContext?) {
        self.context = context
    }
    
    
    
    // MARK: -
    
    func getTokenByServiceName(serviceName: String) -> Promise<String?> {
        if cacheTokenMap.keys.contains(serviceName) {
            return Promise<String?>.resolve(cacheTokenMap[serviceName])
        }
        
        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return Promise<String?>.reject(IMNetworkingError.createCommonError())
        }
        
        return IMTokenDao(db: dbBase).getTokenByName(name: serviceName)
            .then {[weak self] value -> Promise<String?> in
                
                let logStr = "sdk get token from DB, current baseUrl is \(String(describing: value?.baseUrl)), current host is \(String(describing: value?.host)), current token is \(String(describing: value?.token))"
                SDKDebugLog( logStr)
                
                guard let self = self else {
                    return Promise<String?>.resolve(value?.token)
                }
                
                if let tokenString: String = value?.token,tokenString.count > 0 {
                    self.cacheTokenMap[serviceName] = tokenString
                }
                
                return Promise<String?>.resolve(value?.token)
            }
    }
    
    func getHostByServiceName(serviceName: String) -> Promise<String?> {
        
        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return Promise<String?>.reject(IMNetworkingError.createCommonError())
        }
        
        return IMTokenDao(db: dbBase).getTokenByName(name: serviceName)
            .then { value -> Promise<String?> in
                return Promise<String?>.resolve(value?.host)
            }
    }
    
    func insertNet(serviceName: String, host: String, token: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.updateValue(token, forKey: serviceName)
        }

        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return
        }
        
        let tokenModel = IMTokenModel(with: serviceName, tokenStr: token, host: host)
        let _ = IMTokenDao(db: dbBase).insertToken(token: tokenModel)
    }
    
    func insertNet(serviceName: String, token: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.updateValue(token, forKey: serviceName)
        }
        
        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return
        }
        let tokenModel = IMTokenModel(with: serviceName, tokenStr: token)
        let _ = IMTokenDao(db: dbBase).insertToken(token: tokenModel)
    }
    
    func updateToken(serviceName: String, token: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.updateValue(token, forKey: serviceName)
        }

        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return
        }
        let tokenModel = IMTokenModel(with:serviceName, tokenStr: token)
        let _ = IMTokenDao(db: dbBase).updateToken(token: tokenModel)
    }
    
    func clearTokenByServiceName(serviceName: String) {
        if cacheTokenMap.keys.contains(serviceName) {
            cacheTokenMap.removeValue(forKey: serviceName)
        }
        
        guard let dbBase = self.context?.db else {
            dbErrorLog("[\(#function)]: context db is nil")
            return
        }
        let _ = IMTokenDao(db: dbBase).cleanToken(name: serviceName)
    }
    
}

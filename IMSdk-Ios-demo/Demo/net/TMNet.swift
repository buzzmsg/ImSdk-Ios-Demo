//
//  TMNet.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

public let IMServerName = "https://demo-sdk-test-api.rpgqp.com"

public class TMNet: NSObject {
    private(set) var mIs401 = false
    private var mDelegate401 : Delegate401?
    private var mServiceName: String = ""
    private(set) var debugCreateTime: Int = 0

    init(serviceName:String) {
    
        mServiceName = serviceName
    }
    
    static func creat(serviceName: String) -> TMNet {
        
        let net: TMNet = TMNet(serviceName: serviceName)
        return net
    }
    
    func getHost() -> String {
        
//        if let host = TokenManager.getInstance().getHostByServiceName(serviceName: mServiceName), host.count > 0 {
//            return host
//        }

//        if let defaultHost = DefaultHosts[mServiceName] {
//            return defaultHost
//        }
        return IMServerName
    }
    
    func setToken(token:String) -> TMNet {
        if  token != TMTokenManager.EMPTY_TOKEN {
            mIs401 = false
        }
        TMTokenManager.getInstance().insertNet(serviceName: mServiceName, token: token)
        return self
    }
    
    func getToken() -> Promise<String> {
        return TMTokenManager.getInstance().getTokenByServiceName(serviceName: IMServerName)
            .then { token -> Promise<String> in
                
                guard let to = token else {
                    return Promise<String>.reject(TMNetworkingError.createCommonError())
                }
                return Promise<String>.resolve(to)
            }
    }
    
    func set401State(is401:Bool) -> TMNet {
        
        mIs401 = is401
        return self
    }
    
    func clear401State() -> TMNet {
        mIs401 = false
        return self
    }
    
    func set401Delegate(delegate401:Delegate401) -> TMNet {
        mDelegate401 = delegate401
        return self
    }
    
    func get401Delegate() -> Delegate401? {
        return mDelegate401
    }
}

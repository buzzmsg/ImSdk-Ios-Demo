//
//  IMNet.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

let IMSDKApiServiceName: String = "IM_SERVICE_NAME"

public class IMNet: NSObject {
    private(set) var mIs401 = false
    private var mDelegate401 : IMDelegate401?
    private var mServiceName: String = ""
    private var context: IMContext?
    private(set) var debugCreateTime: Int = 0
    
    private(set) var host: String = ""
    private(set) var requestHeader: [String : String] = [:]

    public init(serviceName:String) {
    
        mServiceName = serviceName
    }
    
    static public func creat(serviceName: String) -> IMNet {
        
        let net: IMNet = IMNet(serviceName: serviceName)
        return net
    }
    
    public func setDefaultRequestHeader(ak: String, deviceID: String) {
        self.requestHeader["ak"] = ak
        self.requestHeader["device-id"] = deviceID
    }
    func getDefaultRequestHeader() -> [String : String] {
        return self.requestHeader
    }
    
    public func getHost() -> String {
        
        return self.host
//        if let host = IMTokenManager.getInstance().getHostByServiceName(serviceName: mServiceName), host.count > 0 {
//            return host
//        }

//        if let defaultHost = DefaultHosts[mServiceName] {
//            return defaultHost
//        }
//        return mServiceName
    }
    
    public func setToken(token:String) -> IMNet {
        if  token != IMTokenManager.EMPTY_TOKEN {
            mIs401 = false
        }
        
        if self.host.count <= 0 {
            IMTokenManager(context: context).insertNet(serviceName: mServiceName, token: token)
        }else {
            IMTokenManager(context: context).insertNet(serviceName: mServiceName, host: host, token: token)
        }
        return self
    }
    
    public func setHost(host: String) {
        self.host = host
    }
    
    public func getToken() -> Promise<String> {
        return IMTokenManager(context: context).getTokenByServiceName(serviceName: mServiceName)
            .then { token -> Promise<String> in
                
                guard let to = token else {
                    let logStr = "sdk get local token is nil!"
                    SDKDebugLog( logStr)
                    return Promise<String>.reject(IMNetworkingError.createCommonError())
                }
                return Promise<String>.resolve(to)
            }
    }
    
    public func clearToken() {
        IMTokenManager(context: context).clearTokenByServiceName(serviceName: mServiceName)
    }
    
    public func setContext(context: IMContext) {
        self.context = context
    }
    
    func set401State(is401:Bool) -> IMNet {
        
        mIs401 = is401
        return self
    }
    
    func clear401State() -> IMNet {
        mIs401 = false
        return self
    }
    
    public func set401Delegate(delegate401:IMDelegate401) -> IMNet {
        mDelegate401 = delegate401
        return self
    }
    
    public func get401Delegate() -> IMDelegate401? {
        return mDelegate401
    }
}

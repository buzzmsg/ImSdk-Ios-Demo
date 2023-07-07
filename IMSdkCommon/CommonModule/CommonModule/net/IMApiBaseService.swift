//
//  IMApiBaseService.swift
//  SDK
//
//  Created by oceanMAC on 2022/9/27.
//

import Foundation

public class IMApiBaseService {
    
    static public func post(path: String, parameters: [String: Any]?) -> Promise<String> {
        let net = IMNetFactory.default.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return IMNetCore.shared.apiCore(net: net, path: path, parameters: parameters)
    }
    
    static public func getBaseServiceName() -> String {
        return IMSDKApiServiceName
    }
    
    static public func getBaseHost() -> String {
        let net = IMNetFactory.default.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return net.getHost()
    }
    
//    static func getToken() -> String? {
//        let net = IMNetFactory.default.getNetByServiceName(serviceName: IMServerName)
//        return net.getToken()
//    }
    
//    static public func getToken() -> Promise<String?> {
//        return IMTokenManager.getInstance().getTokenByServiceName(serviceName: IMSDKApiServiceName)
//            .then { token -> Promise<String?> in
//                
//                guard let to = token else {
//                    return Promise<String?>.reject(IMNetworkingError.createCommonError())
//                }
//                return Promise<String?>.resolve(to)
//            }
//    }
    
    static public func set401Delegate(delegate : IMDelegate401) {
        let net = IMNetFactory.default.getNetByServiceName(serviceName: IMSDKApiServiceName)
        let _ = net.set401Delegate(delegate401: delegate)
    }
}

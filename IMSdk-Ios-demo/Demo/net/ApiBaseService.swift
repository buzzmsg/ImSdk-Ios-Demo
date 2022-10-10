//
//  ApiBaseService.swift
//  SDK
//
//  Created by oceanMAC on 2022/9/27.
//

import Foundation

public class ApiBaseService {
    
    static func post(path: String, parameters: [String: Any]?) -> Promise<String> {
        let net = NetFactory.default.getNetByServiceName(serviceName: IMServerName)
        return TMNetCore.shared.apiCore(net: net, path: path, parameters: parameters)
    }
    
    static func getBaseServiceName() -> String {
        return IMServerName
    }
    
    static func getBaseHost() -> String {
        let net = NetFactory.default.getNetByServiceName(serviceName: IMServerName)
        return net.getHost()
    }
    
//    static func getToken() -> String? {
//        let net = NetFactory.default.getNetByServiceName(serviceName: IMServerName)
//        return net.getToken()
//    }
    
    static func getToken() -> Promise<String?> {
        return TMTokenManager.getInstance().getTokenByServiceName(serviceName: IMServerName)
            .then { token -> Promise<String?> in
                
                guard let to = token else {
                    return Promise<String?>.reject(TMNetworkingError.createCommonError())
                }
                return Promise<String?>.resolve(to)
            }
    }
    
    static func set401Delegate(delegate : Delegate401) {
        let net = NetFactory.default.getNetByServiceName(serviceName: IMServerName)
        let _ = net.set401Delegate(delegate401: delegate)
    }
}

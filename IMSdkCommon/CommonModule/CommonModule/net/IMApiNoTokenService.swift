//
//  IMApiNoTokenService.swift
//  SDK
//
//  Created by Joey on 2022/9/28.
//

import Foundation

class IMApiNoTokenService {
    
    static func post(path: String, parameters: [String: Any]?) -> Promise<String> {
        let net = IMNetFactory.default.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return IMNetCore.shared.apiNoTokenCore(net: net, path: path, parameters: parameters)
    }
    
}


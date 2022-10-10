//
//  ApiNoTokenService.swift
//  SDK
//
//  Created by Joey on 2022/9/28.
//

import Foundation

public class ApiNoTokenService {
    
    static func post(path: String, parameters: [String: Any]?) -> Promise<String> {
        let net = NetFactory.default.getNetByServiceName(serviceName: IMServerName)
        return TMNetCore.shared.apiNoTokenCore(net: net, path: path, parameters: parameters)
    }
    
}


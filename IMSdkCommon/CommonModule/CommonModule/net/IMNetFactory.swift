//
//  IMNetFactory.swift
//  SDK
//
//  Created by oceanMAC on 2022/9/27.
//

import Foundation

public class IMNetFactory {
    
    static public let `default` = IMNetFactory()
    private var serviceCacheMap = [String : IMNet]()
    
    public init() {

    }
    
    public func getNetByServiceName(serviceName: String) -> IMNet {
        
        guard let net = serviceCacheMap[serviceName] else {
            
            let newNet = IMNet.creat(serviceName: serviceName)
            serviceCacheMap[serviceName] = newNet
            
            return newNet
        }

        return net
    }

    
    public func cleanAll() {
        serviceCacheMap.removeAll()
    }
    public func cleanNetWithServiceName(serviceName: String) {

        let newNet = serviceCacheMap[serviceName]
        let _ = newNet?.setToken(token: "")
        serviceCacheMap.removeValue(forKey: serviceName)
    }
}

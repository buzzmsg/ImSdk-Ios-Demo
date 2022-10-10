//
//  NetFactory.swift
//  SDK
//
//  Created by oceanMAC on 2022/9/27.
//

import Foundation

public class NetFactory {
    
    static let `default` = NetFactory()
    private var serviceCacheMap = [String : TMNet]()
    
    func getNetByServiceName(serviceName: String) -> TMNet {
        
        guard let net = serviceCacheMap[serviceName] else {
            
            let newNet = TMNet.creat(serviceName: serviceName)
            serviceCacheMap[serviceName] = newNet
            
            return newNet
        }

        return net
    }

    
    func cleanAll() {
        serviceCacheMap.removeAll()
    }
    func cleanNetWithServiceName(serviceName: String) {

        let newNet = serviceCacheMap[serviceName]
        let _ = newNet?.setToken(token: "")
        serviceCacheMap.removeValue(forKey: serviceName)
    }
}

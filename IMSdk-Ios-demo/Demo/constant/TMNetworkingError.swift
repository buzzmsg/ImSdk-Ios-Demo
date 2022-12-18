//
//  TMNetworkingError.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

public class TMNetworkingError: Error {
    /// error code
    @objc var code = -1
    /// error description
    @objc var localizedDescription: String
    
    init(code: Int, desc: String) {
        self.code = code
        self.localizedDescription = desc
    }
    
    init(netError : TMNetError) {
        self.code = netError.rawValue
        switch netError {
        case .NO_NETWORKING:
//            let err = TMSwiftOcBridge.shared.localized(key: R.string.localize.net_something.key) ?? ""
            self.localizedDescription = "Network Error,Please try again"
        default:
            self.localizedDescription = "Network Error,Please try again"
            return
        }
    }
    
    static func createCommonError() -> TMNetworkingError {
        return TMNetworkingError.init(netError: TMNetError.COMMON_ERROR)
    }
}

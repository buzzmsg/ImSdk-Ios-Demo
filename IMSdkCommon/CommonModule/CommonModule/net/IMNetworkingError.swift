//
//  IMNetworkingError.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

public class IMNetworkingError: Error {
    /// error code
    @objc public var code = -1
    /// error description
    @objc public var localizedDescription: String
    
    public init(code: Int, desc: String) {
        self.code = code
        self.localizedDescription = desc
    }
    
    public init(netError : IMNetError) {
        self.code = netError.rawValue
        switch netError {
        case .NO_NETWORKING:
//            let err = TMMSwiftOcBridge.shared.localized(key: R.string.localize.net_something.key) ?? ""
            self.localizedDescription = "Network Error,Please try again"
        default:
            self.localizedDescription = "Network Error,Please try again"
            return
        }
    }
    
    static public func createCommonError() -> IMNetworkingError {
        return IMNetworkingError.init(netError: IMNetError.COMMON_ERROR)
    }
}

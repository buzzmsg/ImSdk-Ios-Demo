//
//  IMSDKMessageId.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import Foundation
class IMSDKMessageId {
    
    private static let create = "createMessage"
    
    static func create(uid : String) -> String {
        let mid = uid + String(Date().milliStamp) + String.random(6) + create
        return mid.DDMD5Encrypt(.lowercase16)
    }

}

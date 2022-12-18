//
//  IMDemoSha1.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import Foundation
import CommonCrypto

class IMDemoSha1{
    static func get(str: String) ->String{
        let data = Data(str.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    static func get(data: Data?) -> String{
//        let data = Data(str.utf8)
        guard let mData = data else {
            return ""
        }
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        _ = CC_SHA1([UInt8](mData), CC_LONG(mData.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

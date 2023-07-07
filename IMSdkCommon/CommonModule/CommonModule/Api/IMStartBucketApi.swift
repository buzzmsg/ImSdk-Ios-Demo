//
//  IMStartBucketApi.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation
import HandyJSON

struct StartBucketResponse: HandyJSON {
    var bucket_id: String?
    var is_accelerate: Bool = false

}

private struct Request {}

struct IMStartBucketApi {
    
    static func execute(nf: IMNetFactory) -> Promise<StartBucketResponse?> {
        
        let net = nf.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return IMNetCore.shared.apiCore(net: net, path: "/startBucket", parameters: nil)
            .then { value -> Promise<StartBucketResponse?> in
                
                let response = StartBucketResponse.deserialize(from: value)
                guard let res = response else {
                    return Promise<StartBucketResponse?>.resolve(nil)
                }
                
                return Promise<StartBucketResponse?>.resolve(res)
            }
    }
    
}

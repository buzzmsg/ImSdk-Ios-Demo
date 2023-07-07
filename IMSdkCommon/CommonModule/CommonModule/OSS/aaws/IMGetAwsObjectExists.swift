//
//  IMGetAwsObjectExists.swift
//  TMM
//
//  Created by  on 2022/5/12.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import HandyJSON

struct IMGetAwsObjectExistsRequest : HandyJSON {
    var bucket_id: String = ""
    var key: String = ""
    
}

struct IMGetAwsObjectExistsResponse: HandyJSON {
    var res: Bool = false
}

public struct IMGetAwsObjectExists {
    
    static public func execute(bucketID: String, key: String, nf: IMNetFactory) -> Promise<Bool> {
        
        if bucketID.isEmpty {
            return Promise<Bool>.resolve(false)
        }

        let request = IMGetAwsObjectExistsRequest(bucket_id: bucketID, key: key)
        let param = IMGetAwsObjectExistsRequest.toJSON(request)()
        
        let net = nf.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return IMNetCore.shared.apiCore(net: net, path: "/getAwsObjectExists", parameters: param)
            .then { value -> Promise<Bool> in
                
                guard let result = IMGetAwsObjectExistsResponse.deserialize(from: value) else {
                    return Promise<Bool>.resolve(false)
                }
                return Promise<Bool>.resolve(result.res)
            }
    }
}


//
//  IMBucketInfo.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import UIKit
import HandyJSON


class BucketInfoResModel : HandyJSON {
    
    var bucketId: String?
    var bucketName: String?
    var baseHost: String?
    var region: String?
    var cropHost: String?
    var sts: [String: Any]?
    var expire: Int?
    var provider: String?
    var accelerateHost: String?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.baseHost <-- "base_host"
        mapper <<<
            self.cropHost <-- "crop_host"
        mapper <<<
            self.bucketId <-- "bucket_id"
        mapper <<<
            self.accelerateHost <-- "accelerate_host"
        mapper <<<
            self.bucketName <-- "bucket_name"
    }
    
}


struct BucketInfoRequest: HandyJSON {
    var bucket_id: String?
}

struct IMBucketInfo {

    static func execute(bucketID: String, nf: IMNetFactory) -> Promise<BucketInfoResModel?> {
        
        if bucketID.isEmpty {
            return Promise<BucketInfoResModel?>.resolve(nil)
        }

        let request = BucketInfoRequest(bucket_id: bucketID)
        let param = BucketInfoRequest.toJSON(request)()
        
        let net = nf.getNetByServiceName(serviceName: IMSDKApiServiceName)
        return IMNetCore.shared.apiCore(net: net, path: "/bucketInfo", parameters: param)
            .then { value -> Promise<BucketInfoResModel?> in
                
                let response = BucketInfoResModel.deserialize(from: value)
                guard let trueRes = response else {
                    return Promise<BucketInfoResModel?>.resolve(nil)
                }
                
                return Promise<BucketInfoResModel?>.resolve(trueRes)
            }
    }
}


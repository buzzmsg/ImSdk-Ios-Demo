//
//  SetMessageStatus.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/10/26.
//

import Foundation
import HandyJSON

struct TMSetMessageStatusRequest: HandyJSON {
    var amid: String = ""
    var auid: String = ""
    var status: Int = 0
}

struct TMSetMessageStatusResponse: HandyJSON {
    var err_code: Int = 0
    var err_msg: String = ""
}


struct SetMessageStatus {
    
    static func execute(amid: String, auid: String, status: Int) -> Promise<Void> {
        
        let request = TMSetMessageStatusRequest.init(amid: amid, auid: auid, status: status)
        let params = TMSetMessageStatusRequest.toJSON(request)()
        
        return ApiNoTokenService.post(path: "/setMessageStatus", parameters: params).then { value in
            
            guard let response = TMSetMessageStatusResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            if response.err_code != 0 {
                return Promise.reject(TMNetworkingError.createCommonError())
            }

            return Promise<Void>.resolve()
        }
        
    }
    
}

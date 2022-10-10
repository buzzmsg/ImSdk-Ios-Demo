//
//  TMDemoGetAuth.swift
//  IMSDKDemo
//
//  Created by Joey on 2022/10/10.
//

import Foundation
import HandyJSON
struct TMDemoGetAuthRequest: HandyJSON {
    var token: String = ""
}

struct TMDemoGetAuthResponse: HandyJSON {
    
    var ak: String = ""
    var auid: String = ""
    var authcode: String = ""
    
}


struct TMDemoGetAuth {
    
    static func execute(token: String) -> Promise<TMDemoGetAuthResponse> {
        
        let request = TMDemoGetAuthRequest.init(token: token)
        let params = TMDemoGetAuthRequest.toJSON(request)()
        
        return ApiNoTokenService.post(path: "/getAuth", parameters: params).then { value in
            
            guard let response = TMDemoGetAuthResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            return Promise<TMDemoGetAuthResponse>.resolve(response)
        }
        
    }
    
}

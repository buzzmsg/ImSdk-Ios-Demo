//
//  TMDemoLogin.swift
//  IMSDK
//
//  Created by Joey on 2022/9/28.
//

import Foundation
import HandyJSON
struct TMDemoLoginRequest: HandyJSON {
    var prefix: String = ""
    var phone: String = ""
}

struct TMDemoLoginResponse: HandyJSON {
    
    var ak: String = ""
    var auid: String = ""
    var authcode: String = ""
    var token: String = ""
    var phone: String = ""
    
}


struct TMDemoLogin {
    
    static func execute(prefix: String, phone: String) -> Promise<TMDemoLoginResponse> {
        
        let request = TMDemoLoginRequest.init(prefix: prefix, phone: phone)
        let params = TMDemoLoginRequest.toJSON(request)()
        
        return ApiNoTokenService.post(path: "/login", parameters: params).then { value in
            
            guard var response = TMDemoLoginResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            response.ak = "68oni7jrg31qcsaijtg76qln"
            response.phone = phone
            return Promise<TMDemoLoginResponse>.resolve(response)
        }
        
    }
    
}

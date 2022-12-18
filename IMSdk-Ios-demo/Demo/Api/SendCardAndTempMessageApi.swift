//
//  SendCardAndTempMessageApi.swift
//  IMSDKDemo
//
//  Created by Joey on 2022/11/1.
//

import Foundation
import HandyJSON

struct SendCardAndTempMessageApiRequest: HandyJSON {
    var achat_id: String = ""
    var sender_id: String = ""
    var send_time: Int = 0
}

struct SendCardAndTempMessageApiResponse: HandyJSON {
    var err_code: Int = 0
    var err_msg: String = ""
    
}


struct SendCardAndTempMessageApi {
    
    static func execute(aChatId: String, aUid: String, sendTime: Int) -> Promise<Void> {
        
        let request = SendCardAndTempMessageApiRequest.init(achat_id: aChatId, sender_id: aUid, send_time: sendTime)
        let params = SendCardAndTempMessageApiRequest.toJSON(request)()
        
        return ApiNoTokenService.post(path: "/sendCardAndTempMessage", parameters: params).then { value in
            
            guard let response = SendCardAndTempMessageApiResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            if response.err_code != 0 {
                return Promise.reject(TMNetworkingError.createCommonError())
            }

            return Promise<Void>.resolve()
        }.catch { error in
            print("\(error)")
            return Promise.reject(error)
        }
        
    }
    
}

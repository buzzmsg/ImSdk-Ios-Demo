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

struct NetApiResponse: HandyJSON {
    var err_code: Int = 0
    var err_msg: String = ""
}

//struct SendResumeMessageApi {
//
//    static func execute(aChatId: String, aUid: String, sendTime: Int) -> Promise<Void> {
//
//        let request = SendCardAndTempMessageApiRequest.init(achat_id: aChatId, sender_id: aUid, send_time: sendTime)
//        let params = SendCardAndTempMessageApiRequest.toJSON(request)()
//
//        return ApiNoTokenService.post(path: "/sendCardAndTempMessage", parameters: params).then { value in
//
//            guard let response = NetApiResponse.deserialize(from: value) else {
//                return Promise.reject(TMNetworkingError.createCommonError())
//            }
//            if response.err_code != 0 {
//                return Promise.reject(TMNetworkingError.createCommonError())
//            }
//            return Promise<Void>.resolve()
//        }.catch { error in
//            print("send resume message error: \(error)")
//            return Promise.reject(error)
//        }
//    }
//}

struct SendCardMessageApi {
    
    static func execute(amid: String, achatId: String, senderId: String) -> Promise<Void> {
        
        let params: [String: Any] = [
            "amid": amid,
            "achat_id": achatId,
            "sender_id": senderId,
        ]
        return ApiNoTokenService.post(path: "/sendCardAndTempMessage", parameters: params).then { value in
            guard let response = NetApiResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            if response.err_code != 0 {
                return Promise.reject(TMNetworkingError.createCommonError())
            }

            return Promise<Void>.resolve()
        }.catch { error in
            print("send card message api error: \(error)")
            return Promise.reject(error)
        }
    }
}

struct SendCustomMessageApi {
    
    static func execute(amid: String, achatId: String) -> Promise<Void> {
        
        let params: [String: Any] = [
            "amid": amid,
            "achat_id": achatId,
        ]
        
        return ApiNoTokenService.post(path: "/sendCustomizeMessage", parameters: params).then { value in
            guard let response = NetApiResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            if response.err_code != 0 {
                return Promise.reject(TMNetworkingError.createCommonError())
            }

            return Promise<Void>.resolve()
        }.catch { error in
            print("send custom message api error: \(error)")
            return Promise.reject(error)
        }
    }
}

struct SendNoticeMessageApi {
    
    static func execute(amid: String, achatId: String, senderId: String) -> Promise<Void> {
        
        let params: [String: Any] = [
            "amid": amid,
//            "achat_id": achatId,
//            "sender_id": senderId,
        ]
        
        return ApiNoTokenService.post(path: "/sendNotificationMessage", parameters: params).then { value in
            guard let response = NetApiResponse.deserialize(from: value) else {
                return Promise.reject(TMNetworkingError.createCommonError())
            }
            if response.err_code != 0 {
                return Promise.reject(TMNetworkingError.createCommonError())
            }

            return Promise<Void>.resolve()
        }.catch { error in
            print("send notice message api error: \(error)")
            return Promise.reject(error)
        }
    }
}


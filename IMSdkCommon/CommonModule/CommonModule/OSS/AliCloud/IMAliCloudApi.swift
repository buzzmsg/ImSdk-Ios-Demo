//
//  IMAliCloudApi.swift
//  TMMIMSdk
//
//  Created by Joey on 2022/10/11.
//

import UIKit
import AliyunOSSiOS
import HandyJSON


class STSModel : HandyJSON {
    
    var access_key_id: String = ""
    var access_key_secret: String = ""
    var session_token: String = ""
    
    required init() {}
}

class IMAliCloudApi: NSObject {

    
    static let shared: IMAliCloudApi = IMAliCloudApi()
    
    private var ossRequestMap: [String : OSSRequest] = [:]
    
    private var clientMap: [String : OSSClient] = [:]
    private var stsMap: [String: STSModel] = [:]
    
    
    func creatClient(endPoint: String, stsModel: STSModel) -> OSSClient {
        
        self.stsMap[endPoint] = stsModel
        
        if let aliClien = self.clientMap[endPoint] {
            return aliClien
        }
        
        let credentialProvider = OSSAuthCredentialProvider(federationTokenGetter: { [weak self] in
            guard let self = self else {  return nil }
            
            if let sts = self.getStsModel(endPoint: endPoint) {
                let aToken: OSSFederationToken = OSSFederationToken()
                aToken.tAccessKey = sts.access_key_id
                aToken.tSecretKey = sts.access_key_secret
                aToken.tToken = sts.session_token
                return aToken
            }
            
            let aToken: OSSFederationToken = OSSFederationToken()
            aToken.tAccessKey = stsModel.access_key_id
            aToken.tSecretKey = stsModel.access_key_secret
            aToken.tToken = stsModel.session_token
            return aToken
        })
        
        let client = OSSClient(endpoint: endPoint, credentialProvider: credentialProvider)
        self.clientMap[endPoint] = client
        return client
    }
    
    
    func getStsModel(endPoint: String) -> STSModel? {
        return self.stsMap[endPoint]
    }
    
    
    // MARK:
    func saveOSSRequest(objectId: String, request: OSSRequest) {
        self.ossRequestMap[objectId] = request
    }
    
    func removeOSSRequest(objectId: String) {
        DispatchQueue.main.async {
            if self.ossRequestMap.keys.contains(objectId) {
                self.ossRequestMap.removeValue(forKey: objectId)
            }
        }
    }
    
    func cancleTask(objectId: String) {
        if let request = self.ossRequestMap[objectId] {
            request.cancel()
            self.removeOSSRequest(objectId: objectId)
        }
    }
    
}

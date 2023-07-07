//
//  IMAwsService.swift
//  TMM
//
//  Created by  on 2021/8/13.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation
import Alamofire

class IMAwsService {
    
    static func downloadApi(url: String, context: IMContext) -> Promise<String> {
        
        return Promise<String> { (reslove, reject) in
            guard let durl: URL = URL(string: url) else {
                reject(IMNetworkingError.createCommonError())
                return
            }
            
            var request: URLRequest = URLRequest(url: durl)
            request.httpMethod = "GET"
            
            let config = URLSessionConfiguration.default
//            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.timeoutIntervalForRequest = 120
            
            let net = context.netFactory.getNetByServiceName(serviceName: IMSDKApiServiceName)
            net.getToken().then { to -> Promise<Void> in
                let head = ["token": to]
                config.httpAdditionalHeaders = head
                let session: URLSession = URLSession(configuration: config)
                
                let dataTask: URLSessionTask = session.dataTask(with: request) { (data, response, error) in
                    
                    DispatchQueue.main.async {
                        if let res = response as? HTTPURLResponse, res.statusCode == 200 {
                            print("Debug Test downloadApi tailoring success! url: \(durl.absoluteString)")
                            reslove("")
                            return
                        }
                        
                        if let res = response as? HTTPURLResponse {
                            
                            var urlStr = durl.absoluteString
                            if let resurl = res.url?.absoluteString, resurl.count > 0 {
                                urlStr = resurl
                            }
                            
                            let str = String(format: "tailoring image failure, code: %i, url: %@", res.statusCode, urlStr)
                            print("Debug Test downloadApi--fail-\(str)")
                        } else {
                            print("Debug Test downloadApi--fail-\(durl)")
                        }
                        
                        reject(IMNetworkingError.createCommonError())
                    }
                }
                dataTask.resume()
                
                return Promise<Void>.resolve()

            }.catch { error in
                return Promise<Void>.reject(error)
            }
            
            

        }
    }
    
}

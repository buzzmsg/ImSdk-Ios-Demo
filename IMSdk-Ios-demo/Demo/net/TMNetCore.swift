//
//  TMNetCore.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation
import Alamofire

public class TMNetCore {

    public static let shared = TMNetCore()

    var sessionManager: Alamofire.SessionManager

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60  // Timeout interval
//        config.timeoutIntervalForResource = 20  // Timeout interval
        config.httpMaximumConnectionsPerHost = 50
        sessionManager = SessionManager(configuration: config)

//        sessionManager = SessionManager(configuration: config)
    }
    
    public func apiCore(net: TMNet,
                        path: String,
                        method: HTTPMethod = .post,
                        parameters: [String : Any]? = nil) -> Promise<String> {
        var parmStr: String = ""
        if let par: String = parameters?.yh_jsonEnCode {
            parmStr = par
        }
        print(parmStr)
        let promiss = Promise<String> {[weak self] (resolve, reject) in
            guard let self = self else { return }
            
            if net.mIs401 {
                let error = TMNetworkingError(netError: TMNetError.TOKEN_ERROR)
                reject(error)
                return
            }
            net.getToken().then { value -> Promise<String> in
                if value == TMTokenManager.EMPTY_TOKEN {
                    self.deal401State(net: net)
                    let error = TMNetworkingError(netError: TMNetError.TOKEN_ERROR)
                    reject(error)
                    return Promise<String>.reject(error)
                }
                
                let netUrl = net.getHost() + path
                let head = self.getHeader(token: value)
                
                self.sessionManager.request(netUrl,
                                       method: method,
                                       parameters: parameters,
                                       encoding: JSONEncoding.default,
                                       headers: head).responseJSON { response in
                    
                    self.requestLog(netUrl: netUrl, method: method, parameters: parameters, headers: head, respon: response, startTime:0)

                    if response.result .isFailure {
                        if let err = response.error,
                           (err._code == TMNetError.NO_NETWORKING.rawValue || err._code == TMNetError.NETWORKING_TIME_OUT.rawValue) {
                            
                            let error = TMNetworkingError(netError:TMNetError.NO_NETWORKING)
                            reject(error)
                            return
                        }
                        let error = TMNetworkingError(netError:TMNetError.COMMON_ERROR)
                        reject(error)
                        return
                    }
                    guard let jsonDic = response.result.value as? [String: Any] else {
                        let error = TMNetworkingError(code: TMNetError.COMMON_ERROR.rawValue, desc: "")
                        reject(error)
                        return
                    }
                    let code = jsonDic["code"] as? Int
                    let msg = jsonDic["msg"] as? String
                    if code == 200{
                        //success
                        let _ = net.clear401State()
                        if let data = jsonDic["data"], data is NSNull {
                            resolve("")
                            return
                        }
                        
                        guard let data = jsonDic["data"] else {
                            resolve("")
                            return
                        }
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                        guard let jData = jsonData, let str = String(data: jData, encoding: .utf8) else {
                            resolve("")
                            return
                        }
                        
                        resolve(str)
                        return
                    }
                    
                    if code != TMNetError.TOKEN_ERROR.rawValue {
                        //other code
                        let _ = net.clear401State()
                        let error = TMNetworkingError(code: code ?? TMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
                        reject(error)
                    } else {

                        //token error code 401
                        net.getToken().then { getToken -> Promise<Void> in
                            if value == getToken {
                                self.deal401State(net: net)
                                let error = TMNetworkingError(code: code ?? TMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
                                reject(error)
                                return Promise<Void>.resolve()
                            }else {
                                let error = TMNetworkingError(netError:TMNetError.COMMON_ERROR)
                                reject(error)
                                return Promise<Void>.resolve()
                            }
                            
                        }
                    }
                }
                return Promise<String>.resolve("")

            }.catch { error -> Promise<String>  in
                self.deal401State(net: net)
                let error = TMNetworkingError(netError: TMNetError.TOKEN_ERROR)
                reject(error)
                return Promise<String>.reject(error)
            }

        }
        
        return promiss
    }
    
    func deal401State(net : TMNet) {

        if net.mIs401 {
            return
        }
        let _ = net.set401State(is401: true)
        net.get401Delegate()?.onTokenError(net: net)
    }
    
    private func getHeader(token:String?) -> [String: String]? {

//        let value = Localize.currentLanguage()
//        var lang = TMLanguage.getCurrentLanguage(systemTag: value)
//        if lang == "zh-Hans" || lang == "zh-hant" {
//            lang = "cn"
//        }
        
        var _header: [String: String] = [:]
        if token != nil && (token?.isEmpty == false) {
            _header["token"] = token
        }
//        _header["version"] = YHGenerated.getBundleInfo(with: .appVersion)
        _header["os"] = "ios"
//        _header["over"] = TM_API.systemVersion
//        _header["lang"] = lang
        _header["Content-Type"] = "application/json"
//        _header["device-name"] = UIDevice.YHMachineName
//        _header["req-id"] = TMDefine.get_ONLYID()

        return _header
    }
    
    public func apiNoTokenCore(net: TMNet,
                               path: String,
                               method: HTTPMethod = .post,
                               parameters: [String: Any]?) -> Promise<String> {
        let netUrl = net.getHost() + path
        let head = getHeader(token: "")

        //let startTime: Int = Date().milliStamp

        let promiss = Promise<String> { (resolve, reject) in
            
            sessionManager.request(netUrl,
                                   method: .post,
                                   parameters: parameters,
                                   encoding: JSONEncoding.default,
                                   headers: head).responseJSON { response in
                  
                                    // test log
                self.requestLog(netUrl: netUrl, method: method, parameters: parameters, headers: head, respon: response, startTime:0)
                                    
                                    if response.result .isFailure {
                                        if let err = response.error,
                                           (err._code == TMNetError.NO_NETWORKING.rawValue || err._code == TMNetError.NETWORKING_TIME_OUT.rawValue) {
                                            
                                            let error = TMNetworkingError(netError:TMNetError.NO_NETWORKING)
                                            reject(error)
                                            return
                                        }
                                        
                                        let error = TMNetworkingError(netError:TMNetError.COMMON_ERROR)
                                        reject(error)
                                        return
                                    }
                                    
                                    guard let jsonDic = response.result.value as? [String: Any] else {
                                        let error = TMNetworkingError(code: TMNetError.COMMON_ERROR.rawValue, desc: "")
                                        reject(error)
                                        return
                                    }
                                    let code = jsonDic["code"] as? Int
                                    let msg = jsonDic["msg"] as? String
                                    
                                    if  code == 200 {
                                        if let data = jsonDic["data"], data is NSNull {
                                            resolve("")
                                            return
                                        }
                                        
                                        guard let data = jsonDic["data"] else {
                                            resolve("")
                                            return
                                        }
                                        
                                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                                        guard let jData = jsonData, let str = String(data: jData, encoding: .utf8) else {
                                            resolve("")
                                            return
                                        }
                                        
                                        resolve(str)
                                        return
                                    } else {
                                        let error = TMNetworkingError(code: code ?? TMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
                                        reject(error)
//                                        delegate.failedHandler?(error)
                                    }
            }
        }
        
        return promiss
    }
    
    
    // MARK: -
    func requestLog(netUrl: String,
                    method: HTTPMethod,
                    parameters: [String: Any]?,
                    headers: [String: Any]?,
                    respon: DataResponse<Any>?,
                    startTime: Int) {
        
//        let responsTime = TimeInterval(Date().timeStamp)
                                       
        DispatchQueue.global().async {
            
            var log = "\n=============================================================================\n\n"
            log += "URL:               \(netUrl)\n"
            log += "Method:            \(method.rawValue)\n"
            log += "Headers:           \(headers ?? [:])\n"
    //        log += "Parameters:        \(parameters ?? [:])\n"
            
//            let stimstr: String = TMTimeTool.default.checkDateString(time: TimeInterval(startTime / 1000), formatString: "yyyy-MM-dd HH:mm:ss")
//            log += "startTime:         \(stimstr) (\(startTime))\n"

//            let etimstr: String = TMTimeTool.default.checkDateString(time: responsTime, formatString: "yyyy-MM-dd HH:mm:ss")
//            log += "responseTime:      \(etimstr)\n"
            
            log += "\n*****************************************************************************\n\n"
            if let value = respon?.value {
                log += "\(value)\n"
            }
            if let error = respon?.error {
                log += "\(error)\n"
            }
            log += "\n=============================================================================\n"
            print(log)
        }

    }
}


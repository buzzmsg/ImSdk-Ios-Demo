//
//  IMNetCore.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation
import Alamofire

public class IMNetCore {

    public static let shared = IMNetCore()

    var sessionManager: Alamofire.SessionManager

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60  // Timeout interval
//        config.timeoutIntervalForResource = 20  // Timeout interval
        config.httpMaximumConnectionsPerHost = 50
        sessionManager = SessionManager(configuration: config)

//        sessionManager = SessionManager(configuration: config)
    }
    
    public func apiCore(net: IMNet,
                        path: String,
                        method: HTTPMethod = .post,
                        parameters: [String : Any]? = nil) -> Promise<String> {
        var parmStr: String = ""
        if let par: String = parameters?.yh_jsonEnCode {
            parmStr = par
        }

        let startTime: Int = Date().milliStamp

        let promiss = Promise<String> {[weak self] (resolve, reject) in
            guard let self = self else { return }
            
            if net.mIs401 {
                net.get401Delegate()?.onTokenError(net: net)
                let error = IMNetworkingError(netError: IMNetError.TOKEN_ERROR)
                reject(error)
                return
            }
            net.getToken().then { netToken -> Promise<String> in
                if netToken == IMTokenManager.EMPTY_TOKEN {
                    let logStr = "Tmm sdk networking api no token, set 401! start: \(startTime), path: \(path)"
                    SDKDebugLog( logStr)
                    self.deal401State(net: net)
                    let error = IMNetworkingError(netError: IMNetError.TOKEN_ERROR)
                    reject(error)
                    return Promise<String>.reject(error)
                }
                
                let logStr = "Tmm sdk networking api 1: start: \(startTime), path: \(path), token: \(netToken), param: \(parmStr)"
                SDKDebugLog(logStr)
                
                let netUrl = net.getHost() + path
                var head = self.getHeader(token: netToken)
                
                let netDefaultHeader = net.getDefaultRequestHeader()
                if head != nil, netDefaultHeader.count > 0 {
                    for (key, val) in netDefaultHeader {
                        head![key] = val
                    }
                }
                SDKDebugLog("Tmm sdk networking api 2: start: \(startTime), headers = \(String(describing: head))")

                self.sessionManager.request(netUrl,
                                       method: method,
                                       parameters: parameters,
                                       encoding: JSONEncoding.default,
                                       headers: head).responseJSON { response in
                    
                    self.requestLog(netUrl: netUrl, method: method, parameters: parameters, headers: head, respon: response, startTime:startTime)
                    
                    if response.result .isFailure {
                        if let err = response.error,
                           (err._code == IMNetError.NO_NETWORKING.rawValue || err._code == IMNetError.NETWORKING_TIME_OUT.rawValue) {
                            
                            let error = IMNetworkingError(netError:IMNetError.NO_NETWORKING)
                            reject(error)
                            return
                        }
                        let error = IMNetworkingError(netError:IMNetError.COMMON_ERROR)
                        reject(error)
                        return
                    }
                    guard let jsonDic = response.result.value as? [String: Any] else {
                        let error = IMNetworkingError(code: IMNetError.COMMON_ERROR.rawValue, desc: "")
                        reject(error)
                        return
                    }
                    let code = jsonDic["code"] as? Int
                    let msg = jsonDic["msg"] as? String
                    if code == 200{
                        net.getToken().then { getToken -> Promise<Void> in
                            if netToken == getToken {
                                //success
                                let _ = net.clear401State()
                                if let data = jsonDic["data"], data is NSNull {
                                    resolve("")
                                    return Promise<Void>.resolve()
                                }
                                
                                guard let data = jsonDic["data"] else {
                                    resolve("")
                                    return Promise<Void>.resolve()
                                }
                                
                                let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                                guard let jData = jsonData, let str = String(data: jData, encoding: .utf8) else {
                                    resolve("")
                                    return Promise<Void>.resolve()
                                }
                                
                                resolve(str)
                                return Promise<Void>.resolve()
                            }else {
                                let error = IMNetworkingError(netError:IMNetError.COMMON_ERROR)
                                reject(error)
                                return Promise<Void>.resolve()
                            }
                            
                        }
                        return
                    }
                    
                    if code != IMNetError.TOKEN_ERROR.rawValue {
                        //other code
                        let _ = net.clear401State()
                        let error = IMNetworkingError(code: code ?? IMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
                        reject(error)
                    } else {

                        //token error code 401
                        net.getToken().then { getToken -> Promise<Void> in
                            if netToken == getToken {
                                let logStr = "Tmm sdk networking api response token error, set 401! netToken: \(netToken), getToken: \(getToken), time: \(Date().milliStamp), path: \(path)"
                                SDKDebugLog( logStr)
                                self.deal401State(net: net)
                                let error = IMNetworkingError(code: code ?? IMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
                                reject(error)
                                return Promise<Void>.resolve()
                            }else {
                                let error = IMNetworkingError(netError:IMNetError.COMMON_ERROR)
                                reject(error)
                                return Promise<Void>.resolve()
                            }
                            
                        }
                    }
                }
                return Promise<String>.resolve("")

            }.catch { error -> Promise<String>  in
                let logStr = "Tmm sdk networking api get token from DB error, set 401! time: \(Date().milliStamp), path: \(path), parameters: \(parmStr)"
                SDKDebugLog( logStr)
                self.deal401State(net: net)
                let error = IMNetworkingError(netError: IMNetError.TOKEN_ERROR)
                reject(error)
                return Promise<String>.reject(error)
            }

        }
        
        return promiss
    }
    
    func deal401State(net : IMNet) {

        if net.mIs401 {
            return
        }
        let _ = net.set401State(is401: true)
        net.get401Delegate()?.onTokenError(net: net)
    }
    
    private func getHeader(token:String?) -> [String: String]? {

//        let value = Localize.currentLanguage()
//        var lang = TMMLanguage.getCurrentLanguage(systemTag: value)
//        if lang == "zh-Hans" || lang == "zh-hant" {
//            lang = "cn"
//        }
        
        var _header: [String: String] = [:]
        if token != nil && (token?.isEmpty == false) {
            _header["token"] = token
        }
//        _header["version"] = TMMGenerated.getBundleInfo(with: .appVersion)
//        _header["over"] = TM_API.systemVersion
//        _header["lang"] = lang
        _header["Content-Type"] = "application/json"
//        _header["device-name"] = UIDevice.YHMachineName
        _header["req-id"] = IMAwsUtil.get_ONLYID()
        _header["version"] = "1.3.0"
        _header["os"] = "ios"

        return _header
    }
    
    public func apiNoTokenCore(net: IMNet,
                               path: String,
                               method: HTTPMethod = .post,
                               parameters: [String: Any]?) -> Promise<String> {
        
        let startTime: Int = Date().milliStamp

        let logStr = "Tmm sdk networking apiNoTokenCore api 1: start: \(startTime), path: \(path), param: \(String(describing: parameters?.yh_jsonEnCode))"
        SDKDebugLog(logStr)
        
        let netUrl = net.getHost() + path
        var head = getHeader(token: "")
        let netDefaultHeader = net.getDefaultRequestHeader()
        if head != nil, netDefaultHeader.count > 0 {
            for (key, val) in netDefaultHeader {
                head![key] = val
            }
        }

        SDKDebugLog("Tmm sdk networking apiNoTokenCore api 2: start: \(startTime), headers = \(String(describing: head))")

        let promiss = Promise<String> { (resolve, reject) in
            
            sessionManager.request(netUrl,
                                   method: .post,
                                   parameters: parameters,
                                   encoding: JSONEncoding.default,
                                   headers: head).responseJSON { response in
                
                // test log
                self.requestLog(netUrl: netUrl, method: method, parameters: parameters, headers: head, respon: response, startTime:startTime)
                
                if response.result .isFailure {
                    if let err = response.error,
                       (err._code == IMNetError.NO_NETWORKING.rawValue || err._code == IMNetError.NETWORKING_TIME_OUT.rawValue) {
                        
                        let error = IMNetworkingError(netError:IMNetError.NO_NETWORKING)
                        reject(error)
                        return
                    }
                    
                    let error = IMNetworkingError(netError:IMNetError.COMMON_ERROR)
                    reject(error)
                    return
                }
                
                guard let jsonDic = response.result.value as? [String: Any] else {
                    let error = IMNetworkingError(code: IMNetError.COMMON_ERROR.rawValue, desc: "")
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
                    let error = IMNetworkingError(code: code ?? IMNetError.COMMON_ERROR.rawValue, desc: msg ?? "")
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
        
        let responsTime = TimeInterval(Date().timeStamp)
                                       
        DispatchQueue.global().async {
            
            var log = "\n=============================================================================\n\n"
            log += "URL:               \(netUrl)\n"
            log += "Method:            \(method.rawValue)\n"
            log += "Headers:           \(headers ?? [:])\n"
    //        log += "Parameters:        \(parameters ?? [:])\n"
            
            let stimstr: String = self.checkDateStringForLog(time: TimeInterval(startTime / 1000), formatString: "yyyy-MM-dd HH:mm:ss")
            log += "startTime:         \(stimstr) (\(startTime))\n"

            let etimstr: String = self.checkDateStringForLog(time: responsTime, formatString: "yyyy-MM-dd HH:mm:ss")
            log += "responseTime:      \(etimstr)\n"
            
            log += "\n*****************************************************************************\n\n"
            if let value = respon?.value {
                log += "\(value)\n"
            }
            if let error = respon?.error {
                log += "error code:      \(error._code)\n"
                log += "error info:      \(error)\n"
            }
            log += "\n=============================================================================\n"
            
            SDKDebugLog(log)
        }

    }
    
    private func checkDateStringForLog(time: TimeInterval, formatString: String = "yyyy-MM-dd H:mm aaa") -> String {
        var dateFormtter = DateFormatter.init()
        dateFormtter.dateFormat = formatString

        let time = Date.init(timeIntervalSince1970: TimeInterval(time))
        let timeStr = dateFormtter.string(from: time)
        return timeStr
    }
    
}


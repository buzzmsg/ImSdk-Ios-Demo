//
//  TMUserUtil.swift
//  IMSDK
//
//  Created by Joey on 2022/9/28.
//

import UIKit
import IMSDK

let TM_DEMO_UID_KEY: String = "demo_uid_key"

//let IMSDKApiHostMap: [IMEnvironmentType : String] = [
//    IMEnvironmentType.alpha : "https://dev-sdk-api.rpgqp.com:7501",
//    // TMMIMEnvironmentType.pre : "https://imsi-pre.tmmtmm.com.tr:6501",
//    IMEnvironmentType.pro : "https://sci.rpgqp.com:5501",
//]
//
//let IMSDKSocketHostMap: [IMEnvironmentType : String] = [
//    IMEnvironmentType.alpha : "wss://dev-sdk-tcp.rpgqp.com:7503",
//    // TMMIMEnvironmentType.pre : "wss://imsws-pre.tmmtmm.com.tr:6502/wsConnect",
//    IMEnvironmentType.pro : "wss://ws.rpgqp.com:5503",
//]

let IMSDKApiHostMap: [IMEnvironmentType : String] = [
    IMEnvironmentType.alpha : "https://dev-sdk-api.buzzmsg.com",
    IMEnvironmentType.pro : "https://sci.buzzmsg.com",
    // TMMIMEnvironmentType.pre : "https://imsi-pre.tmmtmm.com.tr:6501",
]

let IMSDKSocketHostMap: [IMEnvironmentType : String] = [
    IMEnvironmentType.alpha : "wss://dev-sdk-tcp.buzzmsg.com",
    IMEnvironmentType.pro : "wss://ws.buzzmsg.com",
    // TMMIMEnvironmentType.pre : "wss://imsws-pre.tmmtmm.com.tr:6502/wsConnect",
]

let SdkEnvType: IMEnvironmentType = .pro

class TMUserUtil: NSObject {

    static let shared = TMUserUtil()
    
    var loginInfo: TMDemoLoginResponse?
    var isLogged: Bool {
        return loginInfo != nil
    }
    
    var imSdk: IMSdk?
    
    override init() {
        super.init()
        initLoginInfo()
    }
    
    func initLoginInfo() {
        if let value = UserDefaults.standard.value(forKey: TM_DEMO_UID_KEY) as? String {
            loginInfo = TMDemoLoginResponse.deserialize(from: value)
        }
    }
    
    func initIMSdk() {
        guard let info = loginInfo else { return }
        let apiUrl = IMSDKApiHostMap[SdkEnvType] ?? ""
        let wsUrl = IMSDKSocketHostMap[SdkEnvType] ?? ""
        let config = IMSdkConfig(env: SdkEnvType, deviceId: "EF85FBC97E93B993", apiUrl: apiUrl, wsUrl: wsUrl)
        imSdk = IMSdk.getInstance(ak: info.ak, config: config)
        
        // UISetting config
        let uiSetting = IMUISetting()
        uiSetting.setMessageMenu(menuTypes: [IMMessageMenuType.copy.rawValue, IMMessageMenuType.deleteForEveryone.rawValue, IMMessageMenuType.deleteForMe.rawValue])
        uiSetting.showRightAvatar(isShow: true)
        uiSetting.setConversationMenu(isShow: true)
        
        imSdk?.setUISetting(setting: uiSetting)
    }
    
    func saveLoginInfo(info: TMDemoLoginResponse) {
        loginInfo = info
        initIMSdk()
        UserDefaults.standard.set(info.toJSONString(), forKey: TM_DEMO_UID_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func clearLoginInfo() {
        loginInfo = nil
        UserDefaults.standard.removeObject(forKey: TM_DEMO_UID_KEY)
        UserDefaults.standard.synchronize()
    }
}

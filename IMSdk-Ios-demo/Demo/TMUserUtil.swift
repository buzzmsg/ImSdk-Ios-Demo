//
//  TMUserUtil.swift
//  IMSDK
//
//  Created by Joey on 2022/9/28.
//

import UIKit


let TM_DEMO_UID_KEY: String = "demo_uid_key"


class TMUserUtil: NSObject {

    
    static func setLogin(data: TMDemoLoginResponse) {
        UserDefaults.standard.set(data.toJSONString(), forKey: TM_DEMO_UID_KEY)
    }
    
    static func getLogin() -> TMDemoLoginResponse? {
        if let value = UserDefaults.standard.value(forKey: TM_DEMO_UID_KEY) as? String {
            return TMDemoLoginResponse.deserialize(from: value)
        }
        return nil
    }
    
    static func cleanLogin() {
        UserDefaults.standard.removeObject(forKey: TM_DEMO_UID_KEY)
    }
}

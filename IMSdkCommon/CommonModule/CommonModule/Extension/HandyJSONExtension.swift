//
//  HandyJSONExtension.swift
//  TMM
//
//  Created by  on 2022/4/21.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import HandyJSON


extension HandyJSON {
    
    static func deserialize(from dict: NSDictionary?, designatedPath: String? = nil) -> Self? {
        if dict?.allKeys.count == 0 {
            return nil
        }
        return deserialize(from: dict as? [String: Any], designatedPath: designatedPath)
    }
    static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil) -> Self? {
        if dict?.keys.count == 0 {
            return nil
        }
        return JSONDeserializer<Self>.deserializeFrom(dict: dict, designatedPath: designatedPath)
    }
    
    static func deserialize(from json: String?, designatedPath: String? = nil) -> Self? {
        if let _json = json {
            return JSONDeserializer<Self>.deserializeFrom(json: _json, designatedPath: designatedPath)

        }
        return nil

//        if json == nil {
//        }
//        return JSONDeserializer<Self>.deserializeFrom(json: json, designatedPath: designatedPath)
    }
}




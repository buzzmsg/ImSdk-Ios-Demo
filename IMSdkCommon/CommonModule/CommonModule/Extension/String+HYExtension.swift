//
//  String+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/10/12.
//  Copyright © 2019 TMM. All rights reserved.
//

import Foundation


public extension String {
    /// json decode
    var yh_jsonDecode: Any? {
        let data = self.data(using: .utf8)
        guard let _data = data else { return nil }
        return try? JSONSerialization.jsonObject(with: _data, options: .mutableContainers)
    }
    
    static func random(_ count: Int) -> String {

        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< count {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    static func randomNumString(_ count: Int) -> String {
        let letters = "0123456789"
        var s = ""
        for _ in 0 ..< count {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    static func convertValueString(format: String, values: [String]) -> String {
        let valuesMap: [String] = ["%s", "%d",
                                           "%1$s", "%2$s", "%3$s", "%4$s",
                                           "%1$d", "%2$d", "%3$d", "%4$d"]
                
        var matchPlaceholderAry: [String] = []
        valuesMap.forEach { str in
            if format.contains(str) {
                matchPlaceholderAry.append(str)
            }
        }
        
        let idxMap = Array("123456789")

        var temp = format
        for (_, str) in matchPlaceholderAry.enumerated() {
        
            let strSet = Set(Array(str))
            let mapSet = Set(idxMap)
            let interResulet = strSet.intersection(mapSet)
            
            var valueIdx: Int = 0
            if strSet.intersection(mapSet).count > 0, let char = interResulet.first, let idxVal: Int = Int(String(char)) {
                valueIdx = idxVal - 1
            }
            
            if valueIdx >= 0, valueIdx < values.count {
                temp = temp.replacingOccurrences(of: str, with: values[valueIdx])
            }
        }
        return temp
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

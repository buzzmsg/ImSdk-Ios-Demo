//
//  UIImageExtension.swift
//  SDK
//
//  Created by Joey on 2022/10/10.
//

import Foundation
import UIKit

@objc public extension UIImage {
    
    
    static func sdk_bundleImage(imageName: String) -> UIImage? {
        
        var tempName: String = imageName
        if UIScreen.main.scale == 3 {
            tempName = String(format: "%@@3x", imageName)
        }else {
            tempName = String(format: "%@@2x", imageName)
        }
        

//        if let url = Bundle.main.url(forResource: "SDKAssest", withExtension: "bundle"),let bundle = Bundle(url: url) {
        if let url = Bundle.main.url(forResource: "SDKAssest", withExtension: "bundle"),let bundle = Bundle(url: url) {

            let image = UIImage(named: tempName, in: bundle, compatibleWith: nil)
            return image
        }
        return nil
    }
    
    
    static func sdk_bundleSoundPath() -> URL? {
        
        if let url = Bundle.main.url(forResource: "SDKAssest", withExtension: "bundle") {
            let path: String = url.path
            let soundPath: String = path + "/msg_succ.wav"
            return URL(string: soundPath)
        }
        return nil
    }
    
    static func sdk_bundleEmptySoundPath() -> URL? {
        
        if let url = Bundle.main.url(forResource: "SDKAssest", withExtension: "bundle") {
            let path: String = url.path
            let soundPath: String = path + "/detection.aiff"
            return URL(string: soundPath)
        }
        return nil
    }
}




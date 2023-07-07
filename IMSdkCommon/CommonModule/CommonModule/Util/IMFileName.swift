//
//  IMFileName.swift
//  TMM
//
//  Created by  on 2021/8/5.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation
import HandyJSON


public class IMFileName {
    public var tmFileName = ""
    private let FILE_THUMB_IMAGE_PREFIX = "t"
    private let FILE_THUMB_IMAGE_SEPARATOR = "_"
    
    private static let create = "createFileName"
    
    init(fileName: String) {
        tmFileName = fileName
    }
    
//    static func createRandomFileName(fileType : String, context: IMContext) -> FileName {
//        let fileName = IMShareLogic(context.shareDB).getLoginUid() + String(Date().milliStamp)
//            + String.random(6) + create
//        let md5FileName = fileName.DDMD5Encrypt(.lowercase16)
//        return createFileName(fileType: fileType,name: md5FileName)
//    }

    static public func createFileName(fileType: String, name: String) -> IMFileName {
        let fileNameSha1 = IMSHA1.get(str: name)
        let name = fileType + "/" + fileNameSha1.prefix(2) + "/" + fileNameSha1

        return IMFileName.init(fileName: name)
    }
    
    static public func createFileName(fileType: String, fileData: Data?) -> IMFileName {
//        print(String(format: "fileData size: %.2fkb", Float(fileData?.count ?? 0) / 1000))
        let fileNameSha1 = IMSHA1.get(data: fileData)
        let name = fileType + "/" + fileNameSha1.prefix(2) + "/" + fileNameSha1
        
        return IMFileName.init(fileName: name)
    }
    
    static public func createFileName(name: String) -> IMFileName {
        return IMFileName.init(fileName: name)
    }
    
    public func createThumbFileName(width: Int, height: Int) -> String {
        let name = FILE_THUMB_IMAGE_PREFIX
        + FILE_THUMB_IMAGE_SEPARATOR
        + tmFileName
        + FILE_THUMB_IMAGE_SEPARATOR
        + String(width)
        + FILE_THUMB_IMAGE_SEPARATOR
        + String(height)
        return name
    }
    
    func getThumbFileWidth() -> Int {
        if tmFileName.isEmpty {
            return 0
        }
        let suffix = IMCompressPicManager.pathExtension(tmFileName)
        let str = tmFileName.replacingOccurrences(of: ("." + suffix), with: "")
        let split = str.split(separator: Character.init(FILE_THUMB_IMAGE_SEPARATOR))
        if split.count < 4 {
            return 0
        }
        return Int(split[2]) ?? 0
    }
    
    func getThumbFileHeight() ->Int {
        if tmFileName.isEmpty {
            return 0
        }
        let suffix = IMCompressPicManager.pathExtension(tmFileName)
        let str = tmFileName.replacingOccurrences(of: ("." + suffix), with: "")
        let split = str.split(separator: Character.init(FILE_THUMB_IMAGE_SEPARATOR))
        if split.count < 4 {
            return 0
        }
        return Int(split[3]) ?? 0
    }
}

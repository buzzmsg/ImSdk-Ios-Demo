//
//  IMImageUrlParse.swift
//  TMM
//
//  Created by    on 2022/3/28.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import HandyJSON

@objcMembers public class IMImageUrlParse : NSObject, HandyJSON {

    public var bucketId: String = "" // 2ok55satkskw1
    public var format: String = "" // png
    public var objectId: String = ""
    public var thumbWidth: Int = 0 // 200
    public var thumbHeight: Int = 0

    
    public var tempData: Data?
    
    required public override init() {
        
    }
    
    //_img/8d/8dea04d7ca5e2a97f97fb06de17e415c51147eb6   540    404
    static public func create(url: String) -> IMImageUrlParse {
        let format = IMCompressPicManager.pathExtension(url)
        var objectId = ""
        var width: Int = 0
        var height: Int = 0
        
        let mainPath = NSHomeDirectory()
        let documentName: String = IMPathManager.shared.getOssDir().replacingOccurrences(of: mainPath, with: "")
        let urlSplitArr: [String] = url.components(separatedBy: documentName)

        let path: String = urlSplitArr.last ?? ""
        let rootPath = path.replacingOccurrences(of: ("."+format), with: "").replacingOccurrences(of: "t_", with: "") //remove"t_"
        
        
        if rootPath.contains("_") {
            let separatedArray = rootPath.components(separatedBy: "_")
            if separatedArray.count == 0 { //orgin
                objectId = ""
                width = 0
                height = 0
            }else {
                //img/a6/__405_540_1
                if separatedArray.count >= 3 {
                    objectId = separatedArray[0]
                    width = Int(separatedArray[1]) ?? 0
                    height = Int(separatedArray[2]) ?? 0
                }
            }
        }else {
            objectId = rootPath
        }
        

        
        let imageUrlParse = IMImageUrlParse()
        imageUrlParse.format = format
        imageUrlParse.objectId = objectId
        imageUrlParse.thumbWidth = width
        imageUrlParse.thumbHeight = height
        return imageUrlParse
    }
    
    public func getFileFullName() -> String {
        let fileFullName = objectId + "." + format
        return fileFullName
    }

}

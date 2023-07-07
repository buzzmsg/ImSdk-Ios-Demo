//
//  IMAvatarModel.swift
//  TMM
//
//  Created by  on 2021/8/20.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation
import HandyJSON

@objcMembers public class IMAvatarModel : NSObject, HandyJSON {
    
    public var bucketId: String? = "" // 2ok55satkskw1
    public var file_type: String? = "" // png
    public var height: Int = 0
    public var text: String? = ""
    public var width: Int = 0 // 200
    
    public func toModel() -> IMMomentMessageImageContent {
        let model = IMMomentMessageImageContent()

        model.height = height
        model.width = width
        model.fileType = file_type ?? ""
        model.objectId = text ?? ""
        model.bucketId = bucketId ?? ""

        return model
    }
    
    required public override init() {
        
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.file_type <-- ["fileType", "file_type"]
        mapper <<<
            self.text <-- ["objectId", "text"]
    }
    
    public func getFileName() -> String {
        return (text ?? "") + "." + (file_type ?? "")
    }
    
    public func getLocalAvatar() -> String {
        guard let str = text, str.count > 0 else {
            return ""
        }
        
        _ = IMFileName.createFileName(name: text ?? "").tmFileName

//        let avatarFullName = avatarFileName + "." + (file_type ?? "")
        var avatarThumbName = ""
//        if width == 0 || height == 0 {
            avatarThumbName = IMFileName.createFileName(name: text ?? "").tmFileName + "." + (file_type ?? "")
//        }else {
//            let size = IMThumbUtils.init().getAvatarThumb(reqWidth: width ?? 0, reqHeight: height ?? 0)
//            avatarThumbName = IMFileName.createFileName(name: text ?? "")
//                .createThumbFileName(width: size.0, height: size.1)
//            + "." + (file_type ?? "")
//        }
        
        


        let filePath = IMPathManager.shared.getOssDir() + avatarThumbName
        return filePath
    }
    
    public func getRemoteAvatar() -> String {
        
        guard let str = text, str.count > 0 else {
            return ""
        }
        
        let size = IMThumbUtils.init().getAvatarThumb(reqWidth: width , reqHeight: height ?? 0)
        
        let avatarThumbName = IMFileName.createFileName(name: text ?? "")
            .createThumbFileName(width: size.0, height: size.1)
        + "." + (file_type ?? "")

        let filePath =  avatarThumbName
        
        return filePath
    }
    
//    public func getOriginalImagePath() -> String {
//        return TMMFileProgressManager.getFileLocalPath(objectId: text ?? "", fileType: file_type ?? "")
//    }
//    
//    public func getAppletsBannerImagePath(objId: String, fileType: String) -> String {
//        return TMMFileProgressManager.getFileLocalPath(objectId: objId, fileType: fileType)
//    }
    
   

}

@objcMembers public class IMMomentMessageImageContent : NSObject, HandyJSON {
    public var objectId: String = ""
    public var bucketId: String = ""
    public var width: Int = 0
    public var height: Int = 0
    public var mediaType: Int = 0
    public var fileType: String = ""
    required public override init() {
        
    }
}


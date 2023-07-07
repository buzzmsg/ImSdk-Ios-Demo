//
//  IMPathManager.swift
//  TEST
//
//  Created by  on 2021/8/4.
//

import UIKit
import sqlcipher



var filePath : String?//获得文件夹路径，不带后缀
var suffix : String?//获得文件后缀 .png .jpg
var imageName : String?//图片名

let baseFolder = "oss"

private let FILE_OBJECT_SPLICE_POINT = "."
private let FILE_OBJECT_SPLICE_LINE = "_"
private let FILE_OBJECT_SPLICE_SLASH = "/"

@objcMembers public class IMPathManager: NSObject {
    
    public static let shared = IMPathManager()
    private var filePath: String?
    
    //判断文件存不存在-
    public func isFileExists(filePath:String) -> Bool {
        if filePath.contains("/var") {
            let fileManager = FileManager.default
            let exist = fileManager.fileExists(atPath: filePath)
            if !exist
            {
                return false
            }
            return true
        }else {
            let myDirectory:String = self.getOssDir() + "\(filePath)"
            let fileManager = FileManager.default
            let exist = fileManager.fileExists(atPath: myDirectory)
            if !exist
            {
                return false
            }
            return true
        }
    }
    
    //获取沙盒路径
    public func getHomeDirectoryExists() -> String {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        
//        let myDirectory:String = NSHomeDirectory()
        return documentPath + "/"
        
    }

    //创建文件夹并判断文件夹是否存在若不存在自动创建-返回文件夹路径
    public func fileCacheDirectory(filePath:String) -> String {
        
        let myDirectory:String = IMCompressPicManager.deletingLastPathComponent(filePath)
        
        if FileManager.default.fileExists(atPath: myDirectory) == false {
            
            do {
                let fileManager = FileManager.default
                try fileManager.createDirectory(atPath: myDirectory,
                                                withIntermediateDirectories: true, attributes: nil)
                SDKDebugLog("create Path SUCCESS! path: \(myDirectory)")

            } catch {
                SDKDebugLog("create Path fail! error: \(error)")
            }
        }

        return filePath
    }

    //图片转存沙盒路径
    @objc static func picSaveHomeDirectory(image:UIImage?) -> String {
        if (image != nil) {
            guard let imageData = image!.pngData() as NSData? else { return "" }
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            let dat:Date = Date.init(timeIntervalSinceNow: 0)
            let a:TimeInterval = dat.timeIntervalSince1970;
            let timep = UInt64(a)
            let pictureName = "\(timep).png"
            let path = documentPath+"/"+pictureName
            //1.String
            if imageData.write(toFile: path, atomically: true) {
                return path
            } else {
                return ""
            }
        }
        return ""
        
        
//
//        let dat:Date = Date.init(timeIntervalSinceNow: 0)
//        let a:TimeInterval = dat.timeIntervalSince1970;
//        let timep = UInt64(a)
//        let myDirectory:String = NSHomeDirectory() + "/Ducoment/\(timep).png"
//
//        let data:Data = image!.pngData()!
//        try? data.write(to: URL(fileURLWithPath: myDirectory))
//        return myDirectory
    }
    
    static func savePictureAtCommonDirect(image: UIImage?) -> String {
            
        guard let img = image else {
            return ""
        }
        guard let imageData = img.pngData() as NSData? else { return "" }
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let dat:Date = Date.init(timeIntervalSinceNow: 0)
        let a:TimeInterval = dat.timeIntervalSince1970;
        let timep = UInt64(a)
        let pictureName = "\(timep).png"
        
        let direc = documentPath + "/PictureTemp/"
        if FileManager.default.fileExists(atPath: direc) == false {
            try? FileManager.default.createDirectory(atPath: direc, withIntermediateDirectories: true, attributes: nil)
        }
        let path = direc + pictureName
        if imageData.write(toFile: path, atomically: true) {
            return path
        }
        
        return ""
    }
    
    @objc public func picSaveHomeDirectoryWithName(image : UIImage?, path : String) -> String {
        if (image != nil) {
            guard let imageData = image!.pngData() as NSData? else { return "" }
            
            let filePath = self.fileCacheDirectory(filePath: path)
            //1.String
            if imageData.write(toFile: filePath, atomically: true) {
                return path
            } else {
                return ""
            }
        }
        return ""
    }
    
    @objc public func picSaveHomeDirectoryWithName(image:UIImage?, name: String) -> String {
        if (image != nil) {
            guard let imageData = image!.pngData() as NSData? else { return "" }
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            let tmPosterFileName = IMFileName.createFileName(fileType : IMFilePrefixType.FILE_TYPE_IMAGE, name : name)
            let pictureName = "\(tmPosterFileName.tmFileName).png"
            let path = documentPath+"/"+pictureName
            let filePath = self.fileCacheDirectory(filePath: path)
            //1.String
            if imageData.write(toFile: filePath, atomically: true) {
                return path
            } else {
                return ""
            }
        }
        return ""
    }
    
    static func deletePictureAtCommonDirect() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let path = documentPath + "/PictureTemp"
        let fileManager = FileManager.default
        let fileArray = fileManager.subpaths(atPath: path)

        if let ary = fileArray, ary.count > 0 {
            for fn in ary {
                try! fileManager.removeItem(atPath: path + "/\(fn)")
            }
        }

    }
    
    public func saveNewDataFile(data : Data?, filePath : String) -> Promise<Bool> {
        guard var mStream = data else {
            return Promise<Bool>.resolve(false)
        }

        
        let pro = Promise<Bool>.init { res, rej in
            
            DispatchQueue.global().async {
                
                // do something
                var localPath = filePath
                
                let exist = FileManager.default.fileExists(atPath: filePath)
                if !exist {
                    localPath = self.fileCacheDirectory(filePath: filePath)
                }
                
                // conver HEIC image to JPG image
                if filePath.hasSuffix(".HEIC") || filePath.hasSuffix(".heic") {
                    
                    if let ciImage = CIImage(data: mStream), let spac = ciImage.colorSpace {
                        let context = CIContext()
                        if let jpgData = context.jpegRepresentation(of: ciImage, colorSpace: spac) {
                            mStream = jpgData
                            SDKDebugLog("HEIC conver to JPG success!")
                        }
                    }
                }
                  
                
                do {
                    try mStream.write(to: URL(fileURLWithPath: localPath))
                    DispatchQueue.main.async {
                        res(true)
                    }
                } catch {
                    SDKDebugLog("PIC SAVE FAIL\(error)")
                    DispatchQueue.main.async {
                        res(false)
                    }
                }
            }
        }
        return pro
        
        
//        var localPath = filePath
//
//        let exist = FileManager.default.fileExists(atPath: filePath)
//        if !exist {
//            localPath = self.fileCacheDirectory(filePath: filePath)
//        }
//
//        do {
//            try mStream.write(to: URL(fileURLWithPath: localPath))
//            return Promise<Bool>.resolve(true)
//        } catch {
//            SDKDebugLog("PIC SAVE FAIL\(error)")
//
//            return Promise<Bool>.resolve(false)
//        }
    }
    
    //图片转存沙盒路径
    func saveNewfilePath(image:UIImage?, filePath : String, complete: ((_ exist: Bool) -> Void)?) {
        DispatchQueue.global().async {
            if (image != nil) {
                guard let imageData = image!.pngData() as NSData? else {
                    if let comp = complete {
                        comp(false)
                    }
                    return
                }
                
                var localPath = filePath

                let exist = FileManager.default.fileExists(atPath: filePath)
                if !exist {
                    localPath = self.fileCacheDirectory(filePath: filePath)
                }
                
                do {
                    try imageData.write(to: URL(fileURLWithPath: localPath))
                    if let comp = complete {
                        comp(true)
                    }
                } catch {
                    SDKDebugLog("PIC SAVE FAIL\(error)")
                    if let comp = complete {
                        comp(false)
                    }
                }
            }else {
                if let comp = complete {
                    comp(false)
                }
            }
        }
    }
    
    //图片转存沙盒路径
    func saveNewfilePath(imageData:Data?, filePath : String, complete: ((_ exist: Bool) -> Void)?) {
        DispatchQueue.global().async {
            guard let mStream = imageData else {
                if let comp = complete {
                    comp(false)
                }
                return
            }
            var localPath = filePath

            let exist = FileManager.default.fileExists(atPath: filePath)
            if !exist {
                localPath = self.fileCacheDirectory(filePath: filePath)
            }
            
            do {
                try mStream.write(to: URL(fileURLWithPath: localPath))
                if let comp = complete {
                    comp(true)
                }
            } catch {
                SDKDebugLog("PIC SAVE FAIL\(error)")
                if let comp = complete {
                    comp(false)
                }
            }
        }
    }
    
    func saveFileWithOldUrl(tempFile:String, targetFilePath: String) -> Promise<Bool> {
        
        let manager: FileManager = FileManager()
        
        let exist = manager.fileExists(atPath: targetFilePath)
        if exist {
            try? manager.removeItem(atPath: tempFile)
            return Promise<Bool>.resolve(true)
        }
        
        var success: Bool = false
        do {
            try manager.moveItem(at: URL(fileURLWithPath: tempFile), to: URL(fileURLWithPath: targetFilePath))
            SDKDebugLog("[\(self)][\(#function)] save success !! targetFilePath is \(targetFilePath)")
            success = true
            
        } catch  {
            SDKDebugLog("PIC SAVE FAIL\(error)")
        }
        
        try? manager.removeItem(atPath: tempFile)
        return Promise<Bool>.resolve(success)

    }
    
    func saveFileWithPath(targetFilePath: String, dataStr: String) -> Promise<Bool> {
        var localPath = self.getFullFilePath(objectId: targetFilePath)

        let exist = FileManager.default.fileExists(atPath: localPath)
        if !exist {
            localPath = self.fileCacheDirectory(filePath: localPath)
        }
        
        if let data = dataStr.data(using: .utf8) {
            do {
                try data.write(to: URL(fileURLWithPath: localPath))
                SDKDebugLog("PIC SAVE SUCCESS\(localPath)")
                return Promise<Bool>.resolve(true)
            } catch {
                SDKDebugLog("PIC SAVE FAIL\(error)")
                return Promise<Bool>.resolve(false)
            }
        }else {
            return Promise<Bool>.resolve(false)
        }
    }
    
    func saveDataFile(data : Data?, filePath : String) {
        guard let mStream = data else {
            return
        }
//        let lastPath = self.fileCacheDirectory(filePath: filePath)
//        try? mStream.write(to: URL(fileURLWithPath: lastPath))

        // fix big img download failure...
        let lastPath = self.fileCacheDirectory(filePath: filePath)
        let myDirectory:String = IMCompressPicManager.deletingLastPathComponent(filePath)
        let tempPath = NSString(string: filePath)
        let range = tempPath.range(of: myDirectory)
        if range.length > 0, filePath.contains("/var") == false {
            let name = tempPath.substring(from: NSMaxRange(range))
            let path = lastPath + name
            try? mStream.write(to: URL(fileURLWithPath: path))
        } else {
            try? mStream.write(to: URL(fileURLWithPath: lastPath))
        }
    }
    
    //存储图片，传入图片image和图片名
    public func saveFile(imagePath:String?,filePath:String) {
        //获得文件后缀-判断是否是gif，若是gif则不执行存储
//        let lastPath = IMCompressPicManager.lastPathComponent(filePath)
//        let suffix = IMCompressPicManager.pathExtension(filePath)
//        let ishave = IMCompressPicManager.isPngOrJpg(suffix)
//        if !ishave {
//            return
//        }
//        if image == nil {
//            print("no pic")
//            return
//        }
        
        let filePath = self.fileCacheDirectory(filePath: filePath)
        
        let data:Data = NSData.init(contentsOfFile: imagePath!)! as Data
        try? data.write(to: URL(fileURLWithPath: filePath))
    }

    public func saveFile_image(image:UIImage?,filePath:String) {
        //获得文件后缀-判断是否是gif，若是gif则不执行存储
//        let lastPath = IMCompressPicManager.lastPathComponent(filePath)
        
        let suffix = IMCompressPicManager.pathExtension(filePath)
        
        
        let ishave = IMCompressPicManager.isPngOrJpg(suffix)
        if !ishave {
            return
        }
        
        guard let lastImage = image else {
            return
        }

        let lastPath = self.fileCacheDirectory(filePath: filePath)
//        let data:Data = lastImage.pngData()!

        if let data = lastImage.pngData() {
            try? data.write(to: URL(fileURLWithPath: lastPath))
        }
        
        
//        let data:Data = lastImage.pngData()!
//        try? data.write(to: URL(fileURLWithPath: lastPath))

    }
    
    //获取图片
    public func getFile(filePath:String) -> UIImage? {
//        let path = self.fileCacheDirectory(filePath: filePath)
        let fileManagerReadImage = FileManager.default
        let exist = fileManagerReadImage.fileExists(atPath: filePath)
         // 不存在直接返回false
        if (!exist) {
            print("read image fail")
            return nil
        }else{
            let readHandler =  FileHandle(forReadingAtPath: filePath)
            let data = (readHandler?.readDataToEndOfFile())!
            let image = UIImage(data: data)
            print("read image sucess")
            return image!
        }
    }
    
    //裁剪-压缩图片-保存本地缩略图    
//    public func resize(newSize : CGSize, oimage : UIImage, targetPath : String, suffix : String) -> UIImage? {
    public func resize(newSize : CGSize, oimage : UIImage, suffix : String) -> UIImage? {

        
        DispatchQueue.global().sync {
            //全局并发同步
            //获得文件后缀-判断是否是gif，若是gif则不执行压缩等操作
            let ishave = IMCompressPicManager.isPngOrJpg(suffix)
            if !ishave {
                return nil
            }
            
            let clipImage = IMCompressPicManager.imageUserToCompress(forSizeImage: oimage, newSize: newSize)

//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height))
//            let x = -(Int(originalImage!.size.width) - Int(newSize.width)) / 2
//            let y = -(Int(originalImage!.size.height) - Int(newSize.height)) / 2
//            let clipImage = renderer.image { (context) in
//                originalImage!.draw(at: CGPoint(x: x, y: y))
//            }
            
            // https://github.com/webmproject/libwebp.git
            let da = clipImage.pngData()
            var dataCount = 15000.0

            
            if let data = da , data.count > 0 {
                if data.count > 200000 {
                    dataCount = Double(data.count) / 3
                }else if data.count < 15000 {
                    dataCount = 15000.0
//                    self.saveFile_image(image: oimage, filePath: targetPath)
                    return oimage
                } else {
                    dataCount = Double(data.count) / 2
                }
            }
            let lastImage = IMCompressPicManager.compressImageSize(clipImage, toByte: dataCount)

//            self.saveFile_image(image: lastImage, filePath: targetPath)
            return lastImage
        }

    }
    
    public func resize(newSize : CGSize, oimage : UIImage, targetPath: String, suffix : String) -> UIImage? {

        
        DispatchQueue.global().sync {
            //全局并发同步
            //获得文件后缀-判断是否是gif，若是gif则不执行压缩等操作
            let ishave = IMCompressPicManager.isPngOrJpg(suffix)
            if !ishave {
                return nil
            }
            
            let clipImage = IMCompressPicManager.imageUserToCompress(forSizeImage: oimage, newSize: newSize)

//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height))
//            let x = -(Int(originalImage!.size.width) - Int(newSize.width)) / 2
//            let y = -(Int(originalImage!.size.height) - Int(newSize.height)) / 2
//            let clipImage = renderer.image { (context) in
//                originalImage!.draw(at: CGPoint(x: x, y: y))
//            }
            
            // https://github.com/webmproject/libwebp.git
            let da = clipImage.pngData()
            var dataCount = 15000.0

            
            if let data = da , data.count > 0 {
                if data.count > 200000 {
                    dataCount = Double(data.count) / 3
                }else if data.count < 15000 {
                    dataCount = 15000.0
                    self.saveFile_image(image: oimage, filePath: targetPath)
                    return oimage
                } else {
                    dataCount = Double(data.count) / 2
                }
            }
            let lastImage = IMCompressPicManager.compressImageSize(clipImage, toByte: dataCount)

            self.saveFile_image(image: lastImage, filePath: targetPath)
            return lastImage
        }

    }
    
    func getFileData(filePath:String) -> Data? {
        let data = NSData.init(contentsOfFile: filePath)
        return data as Data?
    }
    
    //base file
    public func getOssDir() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let path = documentPath + FILE_OBJECT_SPLICE_SLASH + baseFolder + FILE_OBJECT_SPLICE_SLASH
        return path
    }
    
    //根据thumobject to originalobject   img/xx/xxxx_200_200_1.png -> img/xx/xxxx.png
    public func thumObjectIdTransferOriginalObjectId(thumObjectId: String) -> String {
        let suffix = IMCompressPicManager.pathExtension(thumObjectId)
        let rootPath = thumObjectId.replacingOccurrences(of: (FILE_OBJECT_SPLICE_POINT + suffix), with: "")

        if rootPath.contains(FILE_OBJECT_SPLICE_LINE) {
            let separatedArray = rootPath.components(separatedBy: FILE_OBJECT_SPLICE_LINE)
            if separatedArray.count != 4 { //orgin
                return thumObjectId
            }else {
                return (separatedArray.first ?? "") + FILE_OBJECT_SPLICE_POINT + suffix
            }
        }
        return thumObjectId
    }
    
    //get full path
    public func getFullFilePath(objectId: String) -> String {
        return self.getOssDir() + objectId
    }

//    func getCurrentObjectId(avatarModel: IMAvatarModel, sourceSence: Int, imageType: TmImageType) -> String {
    public func getFileTempModel(avatarModel: IMAvatarModel?, sourceSence: Int, imageType: TmImageType, fileSource: TmFileSource) -> IMImageTempModel {
        let tempModel = IMImageTempModel()
        tempModel.objectId = ""
        tempModel.sourceSence = sourceSence
        tempModel.imageType = imageType
        tempModel.width = 0
        tempModel.height = 0
        tempModel.bucketId = ""
        tempModel.source = fileSource
        
        guard let model = avatarModel else {
            tempModel.defaultImage = self.getDefaultImage(fileSource: fileSource)
            return tempModel
        }
        tempModel.width = model.width
        tempModel.height = model.height
        tempModel.bucketId = model.bucketId ?? ""

        var objectId = ""
        let suffix = model.file_type ?? ""
        if suffix == "gif" || suffix == "GIF" || imageType == TmImageType.original {
            objectId = (model.text ?? "") + FILE_OBJECT_SPLICE_POINT + suffix
        }else {
            var thumbSize: (Int, Int) = (0, 0)
            if imageType == TmImageType.thum {
                
                if sourceSence == IMTransferSence.moments.rawValue {
                    // size rule same to IM
//                    thumbSize = IMThumbUtils.init().getMomentsImgThumb(reqWidth: model.width, reqHeight: model.height)

                    // 720 * 720
                    thumbSize = IMThumbUtils.init().getMomentsImageThumb(reqWidth: model.width, reqHeight: model.height)
                    
                }else if sourceSence == IMTransferSence.IM.rawValue {
                    thumbSize = IMThumbUtils.init().getImgThumb(reqWidth: model.width, reqHeight: model.height)
                }
            }else if imageType == TmImageType.normal {
                thumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: model.width, reqHeight: model.height)
            }
            objectId = (model.text ?? "") + FILE_OBJECT_SPLICE_LINE + String(thumbSize.0) + FILE_OBJECT_SPLICE_LINE + String(thumbSize.1) + FILE_OBJECT_SPLICE_LINE + String(sourceSence) + FILE_OBJECT_SPLICE_POINT + suffix
        }

        tempModel.objectId = objectId
        tempModel.fileType = suffix
        tempModel.defaultImage = self.getDefaultImage(fileSource: fileSource)

        return tempModel
    }
    
    func getDefaultImage(fileSource: TmFileSource) -> UIImage {
        if fileSource == TmFileSource.avatar {
            return UIImage.sdk_bundleImage(imageName: "square_background") ?? UIImage()
        }else if fileSource == TmFileSource.appletsBanner {
            return UIImage.sdk_bundleImage(imageName: "banner_placeholder") ?? UIImage()
        }else {
            return UIImage()
        }
    }
    
//    func headImageAddImage(filePath: String, imageView: YYAnimatedImageView, complete: ((_ exist: Bool, _ image: YYImage) -> Void)?) {
//
//        Promise<YYImage>.resolve(YYImage()).thenByThread { (yyimage: YYImage, resolve, reject) in
//            resolve(YYImage.init(contentsOfFile: filePath))
//        }.then { yyimage -> Promise<Void> in
//
//            if let img = yyimage {
//                imageView.image = img
//
//                if let comp = complete {
//                    comp(true,img)
//                }
//            }else {
//                if let comp = complete {
//                    comp(false,YYImage())
//                }
//            }
//            return Promise<Void>.resolve()
//        }
//    }
    
    // MARK: -

    func saveNewDataFileNew(data : Data?, filePath : String, complete:((Bool) -> ())?) {
        
        guard let mStream = data else {
            if let com = complete {
                com(false)
            }
            return
        }

        
        let exist = FileManager.default.fileExists(atPath: filePath)
        if exist {
            if let com = complete {
                com(true)
            }
            return
        }
           
        let localPath: String = self.fileCacheDirectory(filePath: filePath)

        do {
            try mStream.write(to: URL(fileURLWithPath: localPath))
            if let com = complete {
                com(true)
            }
        } catch {
            SDKDebugLog("PIC SAVE FAIL\(error)")
            if let com = complete {
                com(false)
            }
        }
    }
}

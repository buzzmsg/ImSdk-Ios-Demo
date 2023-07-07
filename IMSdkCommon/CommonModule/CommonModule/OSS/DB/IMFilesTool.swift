//
//  IMFilesTool.swift
//  TMM
//
//  Created by  on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation
import sqlcipher

@objc public class IMFilesTool: NSObject {
    
    public let videoPosterFormat: String = "png"
    
//    func selectImage(tmFile: TMFile, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
//
//        guard let uiImage = UIImage(data: tmFile.fileData) else {
//            SDKDebugLog("selectImage TMFile filedata=nil")
//            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
//        }
//
//        guard let dataBase = ossObject.ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
//        }
//
//        let model = IMImageUrlParse()
//        let isOrigin = tmFile.isSelectOriginalPhoto ? 1 : 0
//        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: tmFile.fileData)
//        if isOrigin == 1 {
//            model.objectId = tmFileName.tmFileName
//            model.thumbWidth = Int(tmFile.attachmentModel.width)
//            model.thumbHeight = Int(tmFile.attachmentModel.height)
//            model.format = tmFile.attachmentModel.fileType
//
//            let eventObjectId: String = model.objectId + "." + tmFile.attachmentModel.fileType
//            let imageOriginFilePath = ossObject.ossPath + eventObjectId
//            return IMPathManager.shared.saveNewDataFile(data: tmFile.fileData, filePath: imageOriginFilePath)
//                .then { saveSuccess -> Promise<IMImageUrlParse>  in
//                    if saveSuccess {
//                        IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                            let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                            let fileDownloadEvent = TMFileDownloadEvent()
//                            fileDownloadEvent.objectIds = [eventObjectId]
//                            notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                            return Promise<Void>.resolve()
//                        }
//                    }else {
//                        let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageOriginFilePath)"
//                        SDKDebugLog(stsStr)
//                    }
//                    return Promise<IMImageUrlParse>.resolve(model)
//                }
//        }else {
//            let bigThumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: Int(tmFile.attachmentModel.width), reqHeight: Int(tmFile.attachmentModel.height))
//            let bigSize = CGSize(width: bigThumbSize.0, height: bigThumbSize.1)
//            let bigThumImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: uiImage, newSize: bigSize)
//            let imageData = IMPhotoManager.compressImage(withImage2: bigThumImage, toByte: 200 * 1024)
//            let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: imageData)
//
//            //img/xx/xxxxxx
//            model.objectId = tmFileName.tmFileName
//
//            model.thumbWidth = bigThumbSize.0
//            model.thumbHeight = bigThumbSize.1
//            model.format = tmFile.attachmentModel.fileType
//
//            let eventObjectId: String = model.objectId + "." + tmFile.attachmentModel.fileType
//            let normalFilePath = ossObject.ossPath + eventObjectId
//
//            return IMPathManager.shared.saveNewDataFile(data: imageData, filePath: normalFilePath)
//                .then { saveSuccess -> Promise<IMImageUrlParse>  in
//                    if saveSuccess {
//                        IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                            let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                            let fileDownloadEvent = TMFileDownloadEvent()
//                            fileDownloadEvent.objectIds = [eventObjectId]
//                            notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                            return Promise<Void>.resolve()
//                        }
//                    }else {
//                        let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(normalFilePath)"
//                        SDKDebugLog(stsStr)
//                    }
//                    return Promise<IMImageUrlParse>.resolve(model)
//                }
//        }
//    }
//
//    func selectattachment(tmFile: TMFile, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
//
//
//        guard let dataBase = ossObject.ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return Promise.reject(IMNetworkingError.createCommonError())
//        }
//
//        let model = IMImageUrlParse()
//        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_ATTACHMENT, fileData: tmFile.fileData)
//        model.objectId = tmFileName.tmFileName
//        model.thumbWidth = Int(tmFile.attachmentModel.width)
//        model.thumbHeight = Int(tmFile.attachmentModel.height)
//        model.format = tmFile.attachmentModel.fileType
//
//        let eventObjectId: String = model.objectId + "." + tmFile.attachmentModel.fileType
//        let originFilePath = ossObject.ossPath + eventObjectId
//        return IMPathManager.shared.saveNewDataFile(data: tmFile.fileData, filePath: originFilePath)
//            .then { saveSuccess -> Promise<IMImageUrlParse>  in
//                if saveSuccess {
//                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                        let fileDownloadEvent = TMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [eventObjectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        return Promise<Void>.resolve()
//                    }
//                }else {
//                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(originFilePath)"
//                    SDKDebugLog(stsStr)
//                }
//                return Promise<IMImageUrlParse>.resolve(model)
//            }
//    }
//
    public func selectVoice(voiceData: Data, format: String, ossObject: IMOSS) -> Promise<IMImageUrlParse> {

        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }

        let model = IMImageUrlParse()
        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_AUDIO, fileData: voiceData)
        model.objectId = tmFileName.tmFileName
        model.format = format

        let eventObjectId: String = model.objectId + "." + format
        let originFilePath = ossObject.ossPath + eventObjectId
        return IMPathManager.shared.saveNewDataFile(data: voiceData, filePath: originFilePath)
            .then { saveSuccess -> Promise<IMImageUrlParse>  in
                if saveSuccess {
                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in

                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [eventObjectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)

                        return Promise<Void>.resolve()
                    }
                }else {
                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(originFilePath)"
                    SDKDebugLog(stsStr)
                }
                return Promise<IMImageUrlParse>.resolve(model)
            }
    }

    public func selectVideoThumImage(coverdata: Data, ossObject: IMOSS) -> Promise<IMImageUrlParse> {

        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }

        guard let coverImage = UIImage(data: coverdata)  else {
            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
        }

        let model = IMImageUrlParse()
//        let thumbSize = IMThumbUtils.init().getImgThumb(reqWidth: Int(tmFile.attachmentModel.width), reqHeight: Int(tmFile.attachmentModel.height))
//        let smallSize = CGSize(width: Int(tmFile.attachmentModel.width), height: Int(tmFile.attachmentModel.height))
//        let thumbImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: coverImage, newSize: smallSize)
        let smallThumImageData = IMPhotoManager.compressImage(withImage2: coverImage, toByte: 100 * 1024)
        let tmPosterFileName = IMFileName.createFileName(fileType : IMFilePrefixType.FILE_TYPE_IMAGE, fileData: smallThumImageData)
        model.objectId = tmPosterFileName.tmFileName
        model.thumbWidth = Int(coverImage.size.width)
        model.thumbHeight = Int(coverImage.size.height)
        model.format = videoPosterFormat

        let eventObjectId: String = model.objectId + "." + videoPosterFormat
        let imageOriginFilePath = ossObject.ossPath + model.objectId + "." + videoPosterFormat
        return IMPathManager.shared.saveNewDataFile(data: smallThumImageData, filePath: imageOriginFilePath)
            .then { saveSuccess -> Promise<IMImageUrlParse>  in
                if saveSuccess {
                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in

                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [eventObjectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)

                        return Promise<Void>.resolve()
                    }
                }else {
                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageOriginFilePath)"
                    SDKDebugLog(stsStr)
                }
                return Promise<IMImageUrlParse>.resolve(model)
            }
    }

    public func selectVideo(data: Data, coverdata: Data, format: String, ossObject: IMOSS) -> Promise<IMImageUrlParse> {

        guard let coverImage = UIImage(data: coverdata)  else {
            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
        }
        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
         }
        

        let model = IMImageUrlParse()
        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_VIDEO, fileData: data)
        model.objectId = tmFileName.tmFileName
        model.thumbWidth = Int(coverImage.size.width)
        model.thumbHeight = Int(coverImage.size.height)
        model.format = format

        let eventObjectId: String = model.objectId + "." + format
        let originFilePath = ossObject.ossPath + eventObjectId
        return IMPathManager.shared.saveNewDataFile(data: data, filePath: originFilePath)
            .then { saveSuccess -> Promise<IMImageUrlParse>  in
                if saveSuccess {
                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in

                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [eventObjectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)
                        return Promise<Void>.resolve()
                    }

                }else {
                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(originFilePath)"
                    SDKDebugLog(stsStr)
                }
                return Promise<IMImageUrlParse>.resolve(model)
            }
    }
//
//    func selectMomentImage(tmFile: TMFile, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
//
//        guard let dataBase = ossObject.ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return Promise.reject(IMNetworkingError.createCommonError())
//        }
//
//        guard let uiImage = UIImage(data: tmFile.fileData) else {
//            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
//        }
//        let attachment = tmFile.attachmentModel
//        let imageFormat = attachment.fileType
//
//        if imageFormat.contains("gif") == true {
//
//            let model = IMImageUrlParse()
//            let width = Int(attachment.width)
//            let height = Int(attachment.height)
//            let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: tmFile.fileData)
//            model.objectId = tmFileName.tmFileName
//            model.thumbWidth = Int(width)
//            model.thumbHeight = Int(height)
//            model.format = imageFormat
//
//            let eventObjectId: String = model.objectId + "." + imageFormat
//            let originFilePath = ossObject.ossPath + eventObjectId
//            return IMPathManager.shared.saveNewDataFile(data: tmFile.fileData, filePath: originFilePath).then { saveSuccess -> Promise<IMImageUrlParse> in
//                if saveSuccess {
//                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                        let fileDownloadEvent = TMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [eventObjectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        return Promise<Void>.resolve()
//                    }
//                }else {
//                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(originFilePath)"
//                    SDKDebugLog(stsStr)
//                }
//                return Promise<IMImageUrlParse>.resolve(model)
//            }
//
//        }else {
//            let model = IMImageUrlParse()
//            let width = Int(attachment.width)
//            let height = Int(attachment.height)
//            let bigThumbSize = IMThumbUtils.init().getMomentsBigImgThumb(reqWidth: width, reqHeight: height)
//            let bigSize = CGSize(width: bigThumbSize.0, height: bigThumbSize.1)
//            let bigImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: uiImage, newSize: bigSize)
//            let smallThumImageData = IMPhotoManager.compressImage(withImage2: bigImage, toByte: 1024 * 1024)
//
//            let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: smallThumImageData)
//            model.objectId = tmFileName.tmFileName
//            model.thumbWidth = Int(bigSize.width)
//            model.thumbHeight = Int(bigSize.height)
//            model.format = imageFormat
//
//            let eventObjectId: String = model.objectId + "." + imageFormat
//            let bigFilePath = ossObject.ossPath + eventObjectId
//
//            return IMPathManager.shared.saveNewDataFile(data: smallThumImageData, filePath: bigFilePath).then { saveSuccess -> Promise<IMImageUrlParse> in
//                if saveSuccess {
//                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                        let fileDownloadEvent = TMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [eventObjectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        return Promise<Void>.resolve()
//                    }
//                }else {
//                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(bigFilePath)"
//                    SDKDebugLog(stsStr)
//                }
//                return Promise<IMImageUrlParse>.resolve(model)
//            }
//        }
//    }
//
//    func selectMomentVideoThumImage(tmFile: TMFile, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
//
//        guard let dataBase = ossObject.ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return Promise.reject(IMNetworkingError.createCommonError())
//        }
//
//        guard let coverImage = UIImage(data: tmFile.videoThumbData)  else {
//            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
//        }
//
//        let model = IMImageUrlParse()
////        let smallThumbSize = IMThumbUtils.init().getMomentsImageThumb(reqWidth: Int(tmFile.attachmentModel.width), reqHeight: Int(tmFile.attachmentModel.height))
////        let smallSize = CGSize(width: smallThumbSize.0, height: smallThumbSize.1)
////        let smallImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: coverImage, newSize: smallSize)
//
//        let smallThumImageData = IMPhotoManager.compressImage(withImage2: coverImage, toByte: 200 * 1024)
//        let tmPosterFileName = IMFileName.createFileName(fileType : IMFilePrefixType.FILE_TYPE_IMAGE, fileData: smallThumImageData)
//        model.objectId = tmPosterFileName.tmFileName
//        model.thumbWidth = Int(tmFile.attachmentModel.width)
//        model.thumbHeight = Int(tmFile.attachmentModel.height)
//        model.format = videoPosterFormat
//
//        let eventObjectId: String = model.objectId + "." + videoPosterFormat
//        let imageOriginFilePath = ossObject.ossPath + eventObjectId
//        return IMPathManager.shared.saveNewDataFile(data: smallThumImageData, filePath: imageOriginFilePath)
//            .then { saveSuccess -> Promise<IMImageUrlParse>  in
//                if saveSuccess {
//                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
//
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                        let fileDownloadEvent = TMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [eventObjectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        return Promise<Void>.resolve()
//                    }
//                }else {
//                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageOriginFilePath)"
//                    SDKDebugLog(stsStr)
//                }
//                return Promise<IMImageUrlParse>.resolve(model)
//            }
//    }
//
//    // MARK: -
//
//    /// clip origin image to thumb samll image if  origin image exist
    @objc static public func getFile(imageModel: IMImageTempModel, ossObject: IMOSS, complete: ((_ exist: Bool, _ objectID: String) -> Void)?) {

        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }


        // eg. objectID: 1234_200x300.png

        if imageModel.objectId.count == 0 {
            if let comp = complete {
                comp(false,imageModel.objectId)
            }
            return
        }


        var originalObject = ""
        var normalObject = ""
        var thumObject = ""

        let imageUrlParse = IMImageUrlParse.create(url: imageModel.objectId)

        //originalObject
        originalObject = imageUrlParse.objectId + "." + imageUrlParse.format

        if imageModel.source != TmFileSource.moments {
            let normalSize: (Int, Int) = IMThumbUtils.init().getBigImgThumb(reqWidth: imageModel.width, reqHeight: imageModel.height)
            normalObject = imageUrlParse.objectId + "_" + String(normalSize.0) + "_" + String(normalSize.1) + "_" + "1." + imageUrlParse.format
        }else {
            normalObject = imageUrlParse.objectId + imageUrlParse.format
        }

        var thumbSize: (Int, Int) = (0, 0)
        var compressRato = 100

        if imageModel.sourceSence == 1, imageModel.imageType == TmImageType.thum { //IM
            thumbSize = IMThumbUtils.init().getImgThumb(reqWidth: imageModel.width, reqHeight: imageModel.height)
        }

        if imageModel.sourceSence == 1, imageModel.imageType == TmImageType.normal { //IM
            compressRato = 200
            thumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: imageModel.width, reqHeight: imageModel.height)
        }

        if imageModel.sourceSence == 2, imageModel.imageType == TmImageType.thum { //moments
//            thumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: imageModel.width, reqHeight: imageModel.height)
            
            thumbSize = IMThumbUtils.init().getMomentsImageThumb(reqWidth: imageModel.width, reqHeight: imageModel.height)
        }


        if imageModel.source == TmFileSource.moments {
            thumObject = imageUrlParse.objectId + "_" + String(thumbSize.0) + "_" + String(thumbSize.1) + "_" + "2." + imageUrlParse.format
        }else {
            thumObject = imageUrlParse.objectId + "_" + String(thumbSize.0) + "_" + String(thumbSize.1) + "_" + "1." + imageUrlParse.format
        }

        
        if FileManager.default.fileExists(atPath: imageModel.filePath) {
            if let comp = complete {
                comp(true,imageModel.objectId)
            }
            return
        }

        if imageModel.imageType == TmImageType.original {
            if let comp = complete {
                comp(false,imageModel.objectId)
            }
            return
        }

        let originalPath: String = ossObject.ossPath + originalObject
        let normalPath: String = ossObject.ossPath + normalObject
//        let thumImagePath: String = ossObject.ossPath + thumObject

        if FileManager.default.fileExists(atPath: originalPath) == true {
            if let comp = complete {
                comp(true,originalObject)
            }

            IMCompressPicManager.imageUserToCompress(forFilePath: originalPath, newSize: CGSize(width: thumbSize.0, height: thumbSize.1)) { smallImage in

                IMPhotoManager.compressImage(smallImage, newSize: CGSize(width: thumbSize.0, height: thumbSize.1)) { smallThumImageData in
                    IMPathManager.shared.saveNewfilePath(imageData: smallThumImageData, filePath: imageModel.filePath) { exist in
                        DispatchQueue.main.async {
                            if exist {

                                let stsStr: String = "original Clip ThumImage complete, save succes!! path: \(imageModel.filePath)"
                                SDKDebugLog(stsStr)

                                if let comp = complete {
                                    comp(true,imageModel.objectId)
                                }

                                IMFileProgressDao(db: dataBase).updateProgress(objectId: imageModel.objectId, progress: IMTransferProgressState.success.rawValue).then({ Void -> Promise<Void> in

                                    let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                                    SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(imageModel.objectId)")
                                    let fileDownloadEvent = IMFileDownloadEvent()
                                    fileDownloadEvent.objectIds = [imageModel.objectId]
                                    notificationManager.post(eventProtocol: fileDownloadEvent)
                                    ossObject.deleagte?.updateFileBusinessSuccess(objectId: imageModel.objectId)

                                    return Promise<Void>.resolve()
                                })

                            }else {
                                if let comp = complete {
                                    comp(false,imageModel.objectId)
                                }
                                let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageModel.filePath)"
                                SDKDebugLog(stsStr)
                            }
                        }
                    }

                }
            }

            return
        }


        if FileManager.default.fileExists(atPath: normalPath) == true {
            if let comp = complete {
                comp(true,normalObject)
            }
            IMCompressPicManager.imageUserToCompress(forFilePath: normalPath, newSize: CGSize(width: thumbSize.0, height: thumbSize.1)) { smallImage in
                IMPhotoManager.compressImage(smallImage, newSize: CGSize(width: thumbSize.0, height: thumbSize.1)) { smallThumImageData in
                    IMPathManager.shared.saveNewfilePath(imageData: smallThumImageData, filePath: imageModel.filePath) { exist in
                        DispatchQueue.main.async {
                            if exist {

                                let stsStr: String = "original Clip ThumImage complete, save succes!! path: \(imageModel.filePath)"
                                SDKDebugLog(stsStr)

                                if let comp = complete {
                                    comp(true,imageModel.objectId)
                                }

                                IMFileProgressDao(db: dataBase).updateProgress(objectId: imageModel.objectId, progress: IMTransferProgressState.success.rawValue).then({ Void -> Promise<Void> in

                                    let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                                    SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(imageModel.objectId)")
                                    let fileDownloadEvent = IMFileDownloadEvent()
                                    fileDownloadEvent.objectIds = [imageModel.objectId]
                                    notificationManager.post(eventProtocol: fileDownloadEvent)
                                    ossObject.deleagte?.updateFileBusinessSuccess(objectId: imageModel.objectId)

                                    return Promise<Void>.resolve()
                                })

                            }else {
                                if let comp = complete {
                                    comp(false,imageModel.objectId)
                                }
                                let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageModel.filePath)"
                                SDKDebugLog(stsStr)
                            }
                        }
                    }

                }
            }
            return
        }

        if let comp = complete {
            comp(false,imageModel.objectId)
        }
        return
    }


    @objc public static func getFile(objectID: String, width:Int, height:Int, ossObject: IMOSS, complete: ((_ exist: Bool, _ objectID: String) -> Void)?) {

        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return
        }

        // eg. objectID: 1234_200x300.png

        let docu: String = ossObject.ossPath

        // small image
        let thumImagePath: String = docu + objectID
        if FileManager.default.fileExists(atPath: thumImagePath) {

            if let comp = complete {
                comp(true,objectID)
            }
            return
        }


        let imageUrlParse = IMImageUrlParse.create(url: objectID)
        let originObjectID = imageUrlParse.getFileFullName()

        // origin image or big image path
        let originalPath: String = docu + originObjectID
        if FileManager.default.fileExists(atPath: originalPath) == false {

            if let comp = complete {
                comp(false,objectID)
            }
            return
        }

//        if let comp = complete {
//            comp(false,objectID)
//        }

        let uiImage = UIImage.init(contentsOfFile: originalPath)
        if let img = uiImage {
            let smallImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: img, newSize: CGSize(width: width, height: height))

            DispatchQueue.global().async {

                let smallThumImageData = IMPhotoManager.compressImage(withImage2: smallImage, toByte: 100 * 1024)

                DispatchQueue.main.async {

                    IMPathManager.shared.saveNewDataFile(data: smallThumImageData, filePath: thumImagePath)
                        .then { saveSuccess -> Promise<Void>  in

                            if saveSuccess {

                                let stsStr: String = "original Clip ThumImage complete, save succes!! path: \(thumImagePath)"
                                SDKDebugLog(stsStr)

                                if let comp = complete {
                                    comp(true,objectID)
                                }

                                IMFileProgressDao(db: dataBase).updateProgress(objectId: objectID, progress: IMTransferProgressState.success.rawValue).then({ Void -> Promise<Void> in


                                    let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)

                                    SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(objectID)")
                                    let fileDownloadEvent = IMFileDownloadEvent()
                                    fileDownloadEvent.objectIds = [objectID]
                                    notificationManager.post(eventProtocol: fileDownloadEvent)
                                    ossObject.deleagte?.updateFileBusinessSuccess(objectId: objectID)

                                    return Promise<Void>.resolve()
                                })

                            }else {
                                if let comp = complete {
                                    comp(false,objectID)
                                }
                                let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(thumImagePath)"
                                SDKDebugLog(stsStr)
                            }
                            return Promise<Void>.resolve()
                        }
                }
            }

        }



    }
//
//    // MARK: -
//
//    @objc static func getCurrentObjectId(originalObjectId: String, width:Int, height:Int, format: String, isThum: Bool) -> String {
//        let parse = IMImageUrlParse.create(url: originalObjectId)
//        var thumbSize = IMThumbUtils.init().getImgThumb(reqWidth: width, reqHeight: height)
//        if isThum == false {
//            thumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: width, reqHeight: height)
//        }
//        if format == "gif" || format == "GIF" {
//            return originalObjectId + "." + format
//        }
//        return parse.objectId + "_" + String(thumbSize.0) + "_" + String(thumbSize.1) + "." + format
//    }
//
//
//
//
//    // MARK: -
//
//    func selectImageNew(tmFile: TMFile, ossObject: IMOSS, complete: ((IMImageUrlParse?, Error?) -> ())?) {
//
//        guard let dataBase = ossObject.ossContext.db else {
//            dbErrorLog("[\(#function)] context db is nil")
//            return
//        }
//
//        guard let uiImage = UIImage(data: tmFile.fileData) else {
//            if let com = complete {
//                com(nil, IMNetworkingError.createCommonError())
//            }
//            return
//        }
//
//
//        let model = IMImageUrlParse()
//        let isOrigin = tmFile.isSelectOriginalPhoto ? 1 : 0
//        let tmFileName1 = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: tmFile.fileData)
//
//        if isOrigin == 1 {
//            model.objectId = tmFileName1.tmFileName
//            model.thumbWidth = Int(tmFile.attachmentModel.width)
//            model.thumbHeight = Int(tmFile.attachmentModel.height)
//            model.format = tmFile.attachmentModel.fileType
//
//            let eventObjectId: String = model.objectId + "." + tmFile.attachmentModel.fileType
//            let imageOriginFilePath = ossObject.ossPath + eventObjectId
//
//            IMPathManager.shared.saveNewDataFileNew(data: tmFile.fileData, filePath: imageOriginFilePath) { saveSuccess in
//
//                if saveSuccess {
//
//                    IMFileProgressDao(db: dataBase).updateProgressNew(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue) { updateSuccess in
//
//                        if updateSuccess {
//                            let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                            let fileDownloadEvent = TMFileDownloadEvent()
//                            fileDownloadEvent.objectIds = [eventObjectId]
//                            notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                        }
//                    }
//                }
//
//                if let com = complete {
//                    com(model, nil)
//                }
//            }
//            return
//        }
//
//
//        let bigThumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: Int(tmFile.attachmentModel.width), reqHeight: Int(tmFile.attachmentModel.height))
//        let bigSize = CGSize(width: bigThumbSize.0, height: bigThumbSize.1)
//        let bigThumImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: uiImage, newSize: bigSize)
//        let imageData = IMPhotoManager.compressImage(withImage2: bigThumImage, toByte: 200 * 1024)
//        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: imageData)
//
//        //img/xx/xxxxxx
//        model.objectId = tmFileName.tmFileName
//
//        model.thumbWidth = bigThumbSize.0
//        model.thumbHeight = bigThumbSize.1
//        model.format = tmFile.attachmentModel.fileType
//
//        let eventObjectId: String = model.objectId + "." + tmFile.attachmentModel.fileType
//        let normalFilePath = ossObject.ossPath + eventObjectId
//
//        IMPathManager.shared.saveNewDataFileNew(data: imageData, filePath: normalFilePath) { saveSuccess in
//
//            if saveSuccess {
//
//                IMFileProgressDao(db: dataBase).updateProgressNew(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue) { updateSuccess in
//
//                    if updateSuccess {
//                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
//
//                        let fileDownloadEvent = TMFileDownloadEvent()
//                        fileDownloadEvent.objectIds = [eventObjectId]
//                        notificationManager.post(eventProtocol: fileDownloadEvent)
//
//                    }
//                }
//            }
//
//            if let com = complete {
//                com(model, nil)
//            }
//        }
//    }
    
    // MARK: -

    /**
     data: image data
     format: image format eg: png
     isOrigin: image is original size, default is True
     */
    static public func selectImage(data: Data, format: String, ossObject: IMOSS, isOrigin: Bool = true) -> Promise<IMImageUrlParse> {
        
        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        guard let uiImage = UIImage(data: data) else {
            print("selectImage TMFile filedata=nil")
            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
        }
        
        let model = IMImageUrlParse()
        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: data)
        if isOrigin == true {
            model.objectId = tmFileName.tmFileName
            model.thumbWidth = Int(uiImage.size.width)
            model.thumbHeight = Int(uiImage.size.height)
            model.format = format
            
            let eventObjectId: String = model.objectId + "." + format
            let imageOriginFilePath = ossObject.ossPath + eventObjectId
            
            
            if FileManager.default.fileExists(atPath: imageOriginFilePath) == true {
                SDKDebugLog("Origin filepath is exist: \(imageOriginFilePath)")
                return Promise<IMImageUrlParse>.resolve(model)
            }
            
            return IMPathManager.shared.saveNewDataFile(data: data, filePath: imageOriginFilePath)
                .then { saveSuccess -> Promise<IMImageUrlParse>  in
                    if saveSuccess {
                        IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
                            
                            SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                            let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
                            let fileDownloadEvent = IMFileDownloadEvent()
                            fileDownloadEvent.objectIds = [eventObjectId]
                            notificationManager.post(eventProtocol: fileDownloadEvent)
                            ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)
                            return Promise<Void>.resolve()
                        }
                    }else {
                        let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(imageOriginFilePath)"
                        SDKDebugLog("\(stsStr)")
                    }
                    return Promise<IMImageUrlParse>.resolve(model)
                }
        }else {
            let bigThumbSize = IMThumbUtils.init().getBigImgThumb(reqWidth: Int(uiImage.size.width), reqHeight: Int(uiImage.size.height))
            let bigSize = CGSize(width: bigThumbSize.0, height: bigThumbSize.1)
            let bigThumImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: uiImage, newSize: bigSize)
            let imageData = IMPhotoManager.compressImage(withImage2: bigThumImage, toByte: 200 * 1024)
            let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: imageData)
            
            //img/xx/xxxxxx
            model.objectId = tmFileName.tmFileName
            
            model.thumbWidth = bigThumbSize.0
            model.thumbHeight = bigThumbSize.1
            model.format = format
            
            let eventObjectId: String = model.objectId + "." + format
            let normalFilePath = ossObject.ossPath + eventObjectId
            
            if FileManager.default.fileExists(atPath: normalFilePath) == true {
                SDKDebugLog("normal filepath is exist: \(normalFilePath)")
                return Promise<IMImageUrlParse>.resolve(model)
            }
            return IMPathManager.shared.saveNewDataFile(data: imageData, filePath: normalFilePath)
                .then { saveSuccess -> Promise<IMImageUrlParse>  in
                    if saveSuccess {
                        IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
                            SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                            let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
                            let fileDownloadEvent = IMFileDownloadEvent()
                            fileDownloadEvent.objectIds = [eventObjectId]
                            notificationManager.post(eventProtocol: fileDownloadEvent)
                            ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)
                            return Promise<Void>.resolve()
                        }
                    }else {
                        let stsStr: String = "normal Clip ThumImage complete, save failure!! path: \(normalFilePath)"
                        SDKDebugLog("\(stsStr)")
                    }
                    return Promise<IMImageUrlParse>.resolve(model)
                } 
        }
        
    }
    
    
    static public func saveCardMessageIcon(iconData: Data, format: String, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
        
        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        guard let uiImage = UIImage(data: iconData) else {
            print("selectImage TMFile filedata=nil")
            return Promise<IMImageUrlParse>.reject(IMNetworkingError.createCommonError())
        }
        
        let size: CGSize = CGSize(width: 100, height: 100)
        let bigThumImage: UIImage = IMCompressPicManager.imageUserToCompress(forSizeImage: uiImage, newSize: size)
        let imageData = IMPhotoManager.compressImage(withImage2: bigThumImage, toByte: 50 * 1024)
        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_IMAGE, fileData: imageData)
        
        //img/xx/xxxxxx
        let model = IMImageUrlParse()
        model.objectId = tmFileName.tmFileName
        
        model.thumbWidth = Int(size.width)
        model.thumbHeight = Int(size.height)
        model.format = format
        
        let eventObjectId: String = model.objectId + "." + format
        let normalFilePath = ossObject.ossPath + eventObjectId
        
        return IMPathManager.shared.saveNewDataFile(data: imageData, filePath: normalFilePath)
            .then { saveSuccess -> Promise<IMImageUrlParse>  in
                if saveSuccess {
                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [eventObjectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)
                        return Promise<Void>.resolve()
                    }
                }else {
                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(normalFilePath)"
                    print(stsStr)
                }
                return Promise<IMImageUrlParse>.resolve(model)
            }
        
    }

    
    static public func selectAttachment(data: Data, format: String, ossObject: IMOSS) -> Promise<IMImageUrlParse> {
        
        guard let dataBase = ossObject.ossContext.db else {
            dbErrorLog("[\(#function)] context db is nil")
            return Promise.reject(IMNetworkingError.createCommonError())
        }
        
        let model = IMImageUrlParse()
        let tmFileName = IMFileName.createFileName(fileType: IMFilePrefixType.FILE_TYPE_ATTACHMENT, fileData: data)
        model.objectId = tmFileName.tmFileName
        model.thumbWidth = 0
        model.thumbHeight = 0
        model.format = format
        
        let eventObjectId: String = model.objectId + "." + format
        let originFilePath = ossObject.ossPath + eventObjectId
        return IMPathManager.shared.saveNewDataFile(data: data, filePath: originFilePath)
            .then { saveSuccess -> Promise<IMImageUrlParse>  in
                if saveSuccess {
                    IMFileProgressDao(db: dataBase).updateProgress(objectId: eventObjectId, progress: IMTransferProgressState.success.rawValue).then { _ -> Promise<Void> in
                        SDKDebugLog("[\(#function)] send IMFileDownloadEvent!!! eventObjectId is \(eventObjectId)")
                        let notificationManager: IMNotificationManager = IMNotificationManager(notific: ossObject.ossContext.nc)
                        let fileDownloadEvent = IMFileDownloadEvent()
                        fileDownloadEvent.objectIds = [eventObjectId]
                        notificationManager.post(eventProtocol: fileDownloadEvent)
                        ossObject.deleagte?.updateFileBusinessSuccess(objectId: eventObjectId)
                        return Promise<Void>.resolve()
                    }
                }else {
                    let stsStr: String = "original Clip ThumImage complete, save failure!! path: \(originFilePath)"
                    print(stsStr)
                }
                return Promise<IMImageUrlParse>.resolve(model)
            }
    }
}



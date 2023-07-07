//
//  IMTransferFactory.swift
//  TMM
//
//  Created by  on 2022/5/17.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit

// upload log infos bucketId
public let UploadLogRecordFileBucketId: String = "44335b0272c2588f"

class IMTransferFactory {
    
    static let Local_Bucket_ID = "local"
    static let provider_aws: String = "aws"
    static let provider_ali: String = "ali"
    
    static func getDownloader(bucketID: String, ossContext: IMContext, objectID: String, isNeedNotice: Int, deleagte: IMOSSDelegate?, oss: IMOSS?) -> Promise<IMDownloader> {
        
        
//        if bucketID == Local_Bucket_ID {
//
//            let imageUrlParse: IMImageUrlParse = IMImageUrlParse.create(url: objectID)
//            imageUrlParse.bucketId = bucketID
//
//            let downloader: IMLocalDownloader = IMLocalDownloader()
//            downloader.objectParse = imageUrlParse
//            return Promise<IMDownloader>.resolve(downloader)
//        }
        
        
        //return IMBucketManager().getBucketInfo(bucketID: bucketID, context: ossContext).then { info -> Promise<IMDownloader> in
        return deleagte!.bucketInfo(bucketID: bucketID).then { info -> Promise<IMDownloader> in
            
            let imageUrlParse: IMImageUrlParse = IMImageUrlParse.create(url: objectID)
            imageUrlParse.bucketId = bucketID
            
            
            // ali service
            if info.provider == provider_ali {

                if bucketID == Local_Bucket_ID {
                    let downloader: IMAliLocalDownloader = IMAliLocalDownloader()
                    downloader.objectParse = imageUrlParse
                    downloader.deleagte = deleagte
                    downloader.oss = oss
                    return Promise<IMDownloader>.resolve(downloader)
                }
                
                if imageUrlParse.thumbWidth == 0 && imageUrlParse.thumbHeight == 0 {
                    let downloader: IMAlOriginDownloader = IMAlOriginDownloader()
                    downloader.objectParse = imageUrlParse
                    downloader.isNeedNotice = isNeedNotice
                    downloader.deleagte = deleagte
                    downloader.oss = oss
                    return Promise<IMDownloader>.resolve(downloader)
                }
                
                let downloader: IMAlThumDownloader = IMAlThumDownloader()
                downloader.objectParse = imageUrlParse
                downloader.isNeedNotice = isNeedNotice
                downloader.deleagte = deleagte
                downloader.oss = oss
                return Promise<IMDownloader>.resolve(downloader)
            }
            

            // aws service
            if bucketID == Local_Bucket_ID {

                let downloader: IMLocalDownloader = IMLocalDownloader()
                downloader.objectParse = imageUrlParse
                downloader.deleagte = deleagte
                downloader.oss = oss
                return Promise<IMDownloader>.resolve(downloader)
            }
            
            if imageUrlParse.thumbWidth == 0 && imageUrlParse.thumbHeight == 0 {
                let downloader: IMNormalDownLoader = IMNormalDownLoader()
                downloader.objectParse = imageUrlParse
                downloader.isNeedNotice = isNeedNotice
                downloader.deleagte = deleagte
                downloader.oss = oss
                return Promise<IMDownloader>.resolve(downloader)
            }
            
            let downloader: IMThumDownLoader = IMThumDownLoader()
            downloader.objectParse = imageUrlParse
            downloader.isNeedNotice = isNeedNotice
            downloader.deleagte = deleagte
            downloader.oss = oss
            return Promise<IMDownloader>.resolve(downloader)
        }
    }
    
    static func getDownloaderIfLocalNotExist(bucketID: String, objectID: String, ossContext: IMContext, deleagte: IMOSSDelegate?, oss: IMOSS?) -> Promise<IMDownloader> {

        //return IMBucketManager().getBucketInfo(bucketID: bucketID, context: ossContext).then { info -> Promise<IMDownloader> in
        return deleagte!.bucketInfo(bucketID: bucketID).then { info -> Promise<IMDownloader> in
            
            let imageUrlParse: IMImageUrlParse = IMImageUrlParse.create(url: objectID)
            imageUrlParse.bucketId = bucketID
            
            if imageUrlParse.thumbWidth == 0 && imageUrlParse.thumbHeight == 0 {
                let downloader: IMNormalDownLoader = IMNormalDownLoader()
                downloader.objectParse = imageUrlParse
                downloader.deleagte = deleagte
                downloader.oss = oss
                return Promise<IMDownloader>.resolve(downloader)
            }
            
            let downloader: IMThumDownLoader = IMThumDownLoader()
            downloader.objectParse = imageUrlParse
            downloader.deleagte = deleagte
            downloader.oss = oss
            return Promise<IMDownloader>.resolve(downloader)
        }
    }
    
    static func getDownloaderIfAliLocalNotExist(bucketID: String, objectID: String, ossContext: IMContext, deleagte: IMOSSDelegate?, oss: IMOSS?) -> Promise<IMDownloader> {

        //return IMBucketManager().getBucketInfo(bucketID: bucketID, context: ossContext).then { info -> Promise<IMDownloader> in
        return deleagte!.bucketInfo(bucketID: bucketID).then { info -> Promise<IMDownloader> in
            
            let imageUrlParse: IMImageUrlParse = IMImageUrlParse.create(url: objectID)
            imageUrlParse.bucketId = bucketID
            
            if imageUrlParse.thumbWidth == 0 && imageUrlParse.thumbHeight == 0 {
                let downloader: IMAlOriginDownloader = IMAlOriginDownloader()
                downloader.objectParse = imageUrlParse
                downloader.deleagte = deleagte
                downloader.oss = oss
                return Promise<IMDownloader>.resolve(downloader)
            }
            
            let downloader: IMAlThumDownloader = IMAlThumDownloader()
            downloader.objectParse = imageUrlParse
            downloader.deleagte = deleagte
            downloader.oss = oss
            return Promise<IMDownloader>.resolve(downloader)
        }
    }
    // MARK: -

    static func creatUploader(bucketId: String, ossContext: IMContext, ossPath: String, progress: IMFileUploadProgress, deleagte: IMOSSDelegate?) -> Promise<IMUploader> {
        
        if bucketId == UploadLogRecordFileBucketId {
            
            // aws upload
//            let uploader: IMLogUploader = IMLogUploader()
//            uploader.bucketId = bucketId
//            return Promise<IMAWSUploader>.resolve(uploader)
            
            // ali cloud updaload
            //return IMBucketManager().getSelfBucketId(context: ossContext).then { value -> Promise<IMUploader> in
            return deleagte!.getSelfBucketId().then { value -> Promise<IMUploader> in
                
                let uploader: IMAlUploader = IMAlUploader(bucketId: value, ossContext: ossContext, ossPath: ossPath, progress: progress, deleagte: deleagte)
                //uploader.bucketId = value
                return Promise<IMUploader>.resolve(uploader)
            }
        }
        
        //return IMBucketManager().getFinalBucketInfo(context: ossContext).then { info -> Promise<IMUploader> in
        return deleagte!.getFinalBucketInfo().then { info -> Promise<IMUploader> in
            
            var tempBucketID: String = info.bucketId ?? ""
            
            if info.provider == provider_ali {
                let uploader: IMAlUploader = IMAlUploader(bucketId: tempBucketID, ossContext: ossContext, ossPath: ossPath, progress: progress, deleagte: deleagte)
                return Promise<IMUploader>.resolve(uploader)
            }
            
            let uploader: IMAWSUploader = IMAWSUploader(bucketId: tempBucketID, ossContext: ossContext, ossPath: ossPath, progress: progress, deleagte: deleagte)
            return Promise<IMUploader>.resolve(uploader)
        }
        
    }
}

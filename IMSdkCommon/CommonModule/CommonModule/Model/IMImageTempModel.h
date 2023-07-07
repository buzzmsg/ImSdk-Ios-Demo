//
//  IMImageTempModel.h
//  TMM
//
//  Created by    on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TmImageType) {
    TmImageType_Thum = 0,       //
    TmImageType_Normal ,    //
    TmImageType_Original,      //
};

typedef NS_ENUM(NSUInteger, TmFileSource) {
    TmFileSource_Avatar = 0,       //
    TmFileSource_Applets ,    //
    TmFileSource_AppletsBanner ,    //
    TmFileSource_Moments,      //
    TmFileSource_TMMIM,      //
    TmFileSource_Other,      //
};

typedef NS_ENUM(NSUInteger, IMDownSenceType) {
    down_Automatic = 0,       //
    down_manual ,    //
};

@interface IMImageTempModel : NSObject

@property (nonatomic, copy) NSString *objectId; // img/xx/xxxx
@property (nonatomic, copy) NSString *bucketId;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger sourceSence;
@property (nonatomic, assign) TmImageType imageType;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) UIImage *defaultImage;

@property (nonatomic, assign) TmFileSource source;

@property (nonatomic, assign) BOOL isShowAnimation;

@property (nonatomic, assign) NSInteger sizeType; //choose Automatic or manual download
@property (nonatomic, assign) IMDownSenceType downSence;

@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, copy) NSString *primaryId;

//sizetype
//changjing
@end

NS_ASSUME_NONNULL_END

//
//  TMImageTempModel.h
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

@interface TMImageTempModel : NSObject

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


@end

NS_ASSUME_NONNULL_END

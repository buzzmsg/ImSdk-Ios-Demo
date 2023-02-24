//
//  IMCallHeadImageView.h
//  TMM
//
//  Created by    on 2022/3/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMImage.h"
#import <CommonModule/CommonModule.h>
//#import "IMImageTempModel.h"

@class TMImageView, IMOSS, IMUISetting;

NS_ASSUME_NONNULL_BEGIN

@interface IMCallHeadImageView : UIView

@property (nonatomic, strong) IMImageTempModel *tempModel;
@property (nonatomic, strong) IMAnimatedImageView *thumImageView;

@property (nonatomic, strong) IMOSS *oss;
@property (nonatomic, strong) IMUISetting *uiSetting;

- (void)showImage:(IMImageTempModel *)tempModel Progress:(void (^)(float progress,BOOL success))progress;

- (void)removeNotice;

@end

NS_ASSUME_NONNULL_END

//
//  IMImageBrowserContainerView.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMImage.h"
#import "IMSDK/IMSDK-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@class IMBrowserVo, IMBrowserVideoPlayView;
@interface IMImageBrowserContainerView : UIView

@property (nonatomic, strong) IMOSS *oss;

@property (nonatomic, strong) UIImage *placeholderImage;//占位图
@property (nonatomic, strong) NSArray <IMBrowserVo *> *browserVos;
@property (nonatomic, strong) id dataSource;
@property (nonatomic, assign) NSInteger currentIndex;//当前下标，下标不能大于image.count
@property (nonatomic, strong) NSArray *toViews;
@property (nonatomic, strong) UIView *toView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) IMBrowserVideoPlayView *videoPlayView;
@property (nonatomic, strong) IMBrowserVo *currentBrowserVo;

@property (nonatomic, copy) void (^whenDidShowImageBrowser)(void);
@property (nonatomic, copy) void (^whenDidHideImageBrowser)(void);
@property (nonatomic, copy) void (^whenNeedUpdateIndex)(IMBrowserVo *vo, NSInteger currentPage, NSInteger totalCount);
@property (nonatomic, copy) void (^whenChangeBackgroundAlpha)(CGFloat alpha);
@property (nonatomic, copy) void(^currentDataIsCode)(BOOL isCode);
@property (nonatomic, copy) void (^whenScanResult)(NSString *result);
@property (nonatomic, copy) void (^whenMoreTool)(void);
@property (nonatomic, copy) void (^whenHideToolView)(BOOL isHide, BOOL isVideo);

@property (nonatomic, assign) CGRect willHideScrollViewFrame;

- (instancetype)initWithBusinessId:(NSString *)businessId currentIndex:(NSInteger)currentIndex;

- (void)showToView:(UIView *)toView placeholderView:(UIView *)placeholderView placeholderImage:(IMImage *)placeholderImage;

- (void)removeShow;

- (void)qrCode;

- (void)downOriginal;

- (void)MoreButtonClick;

@end

NS_ASSUME_NONNULL_END

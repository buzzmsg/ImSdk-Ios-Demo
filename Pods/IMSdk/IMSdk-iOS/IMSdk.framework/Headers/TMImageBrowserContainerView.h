//
//  TMImageBrowserContainerView.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMImage.h"
//#import "TMBrowserVideoPlayView.h"

NS_ASSUME_NONNULL_BEGIN

@class BrowserVo;
@interface TMImageBrowserContainerView : UIView

@property (nonatomic, strong) UIImage *placeholderImage;//占位图
@property (nonatomic, strong) NSArray <BrowserVo *> *browserVos;
@property (nonatomic, strong) id dataSource;
@property (nonatomic, assign) NSInteger currentIndex;//当前下标，下标不能大于image.count
@property (nonatomic, strong) NSArray *toViews;
@property (nonatomic, strong) UIView *toView;

//@property (nonatomic, strong) TMBrowserVideoPlayView *videoPlayView;
@property (nonatomic, strong) BrowserVo *currentBrowserVo;

@property (nonatomic, copy) void (^whenDidShowImageBrowser)(void);
@property (nonatomic, copy) void (^whenDidHideImageBrowser)(void);
@property (nonatomic, copy) void (^whenNeedUpdateIndex)(BrowserVo *vo, NSInteger currentPage, NSInteger totalCount);
@property (nonatomic, copy) void (^whenChangeBackgroundAlpha)(CGFloat alpha);
@property (nonatomic, copy) void(^currentDataIsCode)(BOOL isCode);
@property (nonatomic, copy) void (^whenScanResult)(NSString *result);
@property (nonatomic, copy) void (^whenMoreTool)();
@property (nonatomic, copy) void (^whenHideToolView)(BOOL isHide, BOOL isVideo);

- (instancetype)initWithBusinessId:(NSString *)businessId currentIndex:(NSInteger)currentIndex;

- (void)showToView:(UIView *)toView placeholderView:(UIView *)placeholderView placeholderImage:(TMImage *)placeholderImage;

- (void)removeShow;

- (void)qrCode;

- (void)downOriginal;

- (void)MoreButtonClick;

@end

NS_ASSUME_NONNULL_END

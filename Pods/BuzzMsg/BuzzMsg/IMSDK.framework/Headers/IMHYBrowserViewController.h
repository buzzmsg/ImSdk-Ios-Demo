//
//  IMHYBrowserViewController.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BrowserCheckDelegate <NSObject>

/*
 viewFrame: imageview frame on window
 */
- (void)panGestureCloseVC:(CGRect)viewFrame backgroundColor: (UIColor *)color alpha: (CGFloat)alpha;

@end

@class IMOSS;

@interface IMHYBrowserViewController : UIViewController

@property (nonatomic, strong) IMOSS *oss;
@property (nonatomic, assign) BOOL showContainerWithAnimation;


@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong) IMImage *placeholderImage;
@property (nonatomic, strong) id dataSource;
@property (nonatomic, strong) UIImage *screenshotsImage;
@property (nonatomic, strong) NSArray *toViews;
@property (nonatomic,weak) id<BrowserCheckDelegate> delegate;

- (void)show;

- (void)showImageBrowser;

- (void)needUpdateIndex:(NSInteger )currentPage totalCount:(NSInteger )totalCount isVideo:(BOOL)isVideo isFullImage:(BOOL)isFullImage imageSize:(long)imageSize;

- (void)qrCode:(BOOL)isCode;

- (void)moreTool;

- (void)SaveData;

- (void)ShareData;

- (void)startQrCode;

- (void)removeShow;

- (void)downOriginal;

- (void)hideToolView:(BOOL)isHide isVideo:(BOOL)isVideo;

- (void)readyStartQrCode;




- (NSString *) getAssetPath;

- (NSInteger) getAssetOriginStatus;

@end

NS_ASSUME_NONNULL_END

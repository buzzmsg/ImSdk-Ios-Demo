//
//  TMHYBrowserViewController.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BrowserCheckDelegate <NSObject>

- (void)panGestureCloseVC;

@end

@interface TMHYBrowserViewController : UIViewController


@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong) TMImage *placeholderImage;
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

@end

NS_ASSUME_NONNULL_END

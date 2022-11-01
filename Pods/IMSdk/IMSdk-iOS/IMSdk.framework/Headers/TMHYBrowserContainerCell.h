//
//  TMHYBrowserContainerCell.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMImage.h"
#import "TMCallHeadImageView.h"

NS_ASSUME_NONNULL_BEGIN

@class BrowserVo;

@interface TMHYBrowserContainerCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *placeholderImage;//占位图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TMCallHeadImageView *browserImageView;
@property (nonatomic, strong) BrowserVo *cellModel;
@property (nonatomic, weak) UIView *weakBackgroundView;
@property (nonatomic, strong) id dataSource;
@property (nonatomic, assign) BOOL isDownOriginal;
@property (nonatomic, strong) UIView *videoView;

//用户单击0，用户双击1，用户下滑上滑退出2
@property (nonatomic, copy) void(^whenTapOneActionClick)(TMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenTapTwoActionClick)(TMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenNeedHideAction)(TMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenTapLongActionClick)(TMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenVideoDownSuccessActionClick)(TMHYBrowserContainerCell *cell);


@property (nonatomic, copy) void(^whenChangeBackgroundAlpha)(CGFloat alpha);


@end

NS_ASSUME_NONNULL_END

//
//  IMHYBrowserContainerCell.h
//  TMM
//
//  Created by    on 2022/4/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMImage.h"
#import "IMCallHeadImageView.h"

NS_ASSUME_NONNULL_BEGIN

@class IMBrowserVo;

@interface IMHYBrowserContainerCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *placeholderImage;//占位图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IMCallHeadImageView *browserImageView;
@property (nonatomic, strong) IMBrowserVo *cellModel;
@property (nonatomic, weak) UIView *weakBackgroundView;
@property (nonatomic, strong) id dataSource;
@property (nonatomic, assign) BOOL isDownOriginal;
@property (nonatomic, strong) UIView *videoView;

//用户单击0，用户双击1，用户下滑上滑退出2
@property (nonatomic, copy) void(^whenTapOneActionClick)(IMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenTapTwoActionClick)(IMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenNeedHideAction)(IMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenTapLongActionClick)(IMHYBrowserContainerCell *cell);
@property (nonatomic, copy) void(^whenVideoDownSuccessActionClick)(IMHYBrowserContainerCell *cell);


@property (nonatomic, copy) void(^whenChangeBackgroundAlpha)(CGFloat alpha);


@end

NS_ASSUME_NONNULL_END

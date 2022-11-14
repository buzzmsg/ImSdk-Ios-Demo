//
//  TMCallHeadImageView.h
//  TMM
//
//  Created by    on 2022/3/15.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMImage.h"
#import "TMImageTempModel.h"

@class TMImageView;

NS_ASSUME_NONNULL_BEGIN

@interface TMCallHeadImageView : UIView

@property (nonatomic, strong) TMImageTempModel *tempModel;
@property (nonatomic, strong) TMAnimatedImageView *thumImageView;

- (void)showImage:(TMImageTempModel *)tempModel Progress:(void (^)(float progress,BOOL success))progress;

- (void)removeNotice;

@end

NS_ASSUME_NONNULL_END

//
//  UIView+TMImageBrowser.h
//  KKImageBrowser_Example
//
//  Created by Hansen on 11/18/21.
//  Copyright © 2021 chenghengsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KKImageBrowser)

- (UIImage *)screenshotsImageWithScale:(CGFloat)scale;

- (UIImage *)screenshotsImage;

- (UIImage *)imageWithView;

- (UIImage *)screenshotWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

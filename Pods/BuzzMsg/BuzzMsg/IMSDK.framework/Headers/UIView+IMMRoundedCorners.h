//
//  UIView+TMMRoundedCorners.h
//  TMM
//
//   on 2021/8/10.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMMShowBasicAnimationCorner)
{
    TMMShowBasicAnimationCornerTopLeft,
    TMMShowBasicAnimationCornerTopRight,
    TMMShowBasicAnimationCornerTopLeftThree,
    TMMShowBasicAnimationCornerTopRightThree,
    TMMShowBasicAnimationCornerBottomLeft,
    TMMShowBasicAnimationCornerBottomRight,
};


@interface UIView (IMMRoundedCorners)
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
 
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


- (UIView *)copyView;


- (void)hideBasicAnimation: (CFTimeInterval)duration;

/// CAKeyframeAnimation, default values: @[@0, @1.03, @1.0]
- (void)showPopupAnimation: (CFTimeInterval)duration corner: (TMMShowBasicAnimationCorner) corner;


+ (BOOL)isShowKeyboardVisible;
+ (UIWindow * _Nullable)getKeyboardWindow;
+ (UIView * _Nullable)getKeyboardView;

@end

NS_ASSUME_NONNULL_END

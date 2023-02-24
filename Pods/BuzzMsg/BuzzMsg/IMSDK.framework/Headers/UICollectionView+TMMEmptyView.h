//
//  UICollectionView+TMMEmptyView.h
//  OrderMeals
//
//  Created by chong on 2020/4/16.
//  Copyright © 2020 chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (TMMEmptyView)

@property (nonatomic, strong) QMUIEmptyView *emptyView;

//-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title;

-(void)hideEmptyView;

- (void)updateEmptyViewWithImageName:(NSString *)imageName title:(NSString *)title;

- (void)setEmptyViewWithImageName:(NSString *)imageName title:(NSString *)title detail:(NSString *)detail;

- (void)updateEmptyViewWithImageName:(nullable NSString *)imageName
                                text:(nullable NSString *)text
                         buttonTitle:(nullable NSString *)buttonTitle;

@end

NS_ASSUME_NONNULL_END

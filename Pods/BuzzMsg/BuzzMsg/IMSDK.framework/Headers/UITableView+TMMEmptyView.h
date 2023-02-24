//
//  UITableView+TMMEmptyView.h
//  MYSaSClerk
//
//  Created by  on 2019/11/16.
//  Copyright © 2019 chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import "TMMEmptyButtonConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^buttonEvent_t)(UIButton *button);


@interface UITableView (TMMEmptyView)

@property (nonatomic, strong) QMUIEmptyView *emptyView;

//-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title;

-(void)hideEmptyView;
- (void)showEmptView;
- (void)setEmptyViewWithImageName:(NSString *)imageName title:(NSString *)title detail:(NSString *)detail;
- (void)updateEmptyViewWithImageName:(NSString *)imageName title:(NSString *)title;

- (void)updateEmptyViewWithImageName:(NSString *)imageName title:(NSString *)title des:(NSString *)des;

//- (void)updateEmptyViewWithImageName:(NSString *)imageName
//                                text:(NSString *)text
//                         buttonTitle:(NSString * _Nullable)buttonTitle;
//
- (void)updateEmptyViewWithImageName:(NSString *)imageName
                                text:(NSString *)text
                                 des:(NSString *)des
                         button:(TMMEmptyButtonConfig * _Nullable)config
                               event:(__nullable buttonEvent_t)event;

@end

NS_ASSUME_NONNULL_END

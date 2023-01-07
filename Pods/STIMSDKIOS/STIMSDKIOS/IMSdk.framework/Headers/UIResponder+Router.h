//
//  UIResponder+Router.h
//  MYSaSClerk
//
//  Created by chong on 2019/12/7.
//  Copyright © 2019 chong. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
  跨层级传值
 */
@interface UIResponder (Router)


/// 层级传值:需要响应的位置重写该方法即可; 前提：响应者必须在Responder响应链上
/// @param eventName 传值事件
/// @param userInfo 值信息
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

- (void)routerWithEventName:(NSString *)eventName object:(id)object;

@end


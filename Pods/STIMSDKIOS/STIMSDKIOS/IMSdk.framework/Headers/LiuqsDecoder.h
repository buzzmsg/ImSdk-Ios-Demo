//
//  LiuqsDecoder.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/***********************这是一个转码工具类***************************/

@class TMSelectAtModel;

@interface LiuqsDecoder : NSObject

@property (nonatomic, assign) BOOL isDraft;

/*
 * 转码方法，把普通字符串转为富文本字符串（包含图片文字等）
 * 参数 font 是用来展示的字体大小
 * 参数 plainStr 是普通的字符串
 * 返回值：用来展示的富文本，直接复制给label展示
 */
+ (NSMutableAttributedString *)decodeWithPlainStr:(NSString *)plainStr font:(NSInteger)font textColor:(UIColor *)textColor;
+ (NSMutableAttributedString *)decodeWithPlainStr:(NSString *)plainStr atPersons:(NSArray<TMSelectAtModel *> *)atPersons font:(NSInteger)font textColor:(UIColor *)textColor;

+ (NSMutableAttributedString *)draftDecodeWithPlainStr:(NSString *)plainStr atPersons:(NSArray<TMSelectAtModel *> *)atPersons font:(NSInteger)font textColor:(UIColor *)textColor textViewWidth:(CGFloat)textViewWidth;


@end

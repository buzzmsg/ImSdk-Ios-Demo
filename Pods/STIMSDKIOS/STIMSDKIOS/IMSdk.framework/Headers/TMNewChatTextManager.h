//
//  TMNewChatTextManager.h
//  TMM
//
//  Created by    on 2022/1/20.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@class TMSelectAtModel;
@interface TMNewChatTextManager : NSObject
+(TMNewChatTextManager *)shared;


- (CGSize)getContentSize:(NSString *)text MaxWidth:(CGFloat)width atPersons:(NSArray<TMSelectAtModel *> *)atPersons timeText:(NSString *)timeText contentFontSize:(CGFloat)contentFontSize timeFontSize:(CGFloat)timeFontSize isInComingMessage:(BOOL)isInComingMessage;

//size-- contnt
- (CGSize)getContentSize:(NSString *)text MaxWidth:(CGFloat)width fontSize:(CGFloat)fontSize atPersons:(NSArray<TMSelectAtModel *> *)atPersons;

//
- (NSAttributedString *)getAtt:(NSString *)text lineBreakMode:(NSLineBreakMode)lineBreakMode font:(UIFont *)font;
- (NSArray *)getLinesArrayOfStringInLabel:(NSAttributedString *)attStr MaxWidth:(CGFloat)MaxWidth fontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END

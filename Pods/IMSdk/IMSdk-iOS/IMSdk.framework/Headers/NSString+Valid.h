//
//  NSString+Valid.h
//  TMM
//
//  Created by  on 2020/11/4.
//  Copyright © 2020 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Valid)


- (NSString *)filterSpaceAndNewline;

- (BOOL)notOnlySpaceAndNewline;

+ (BOOL)checkUrlWithString:(NSString *)url;
/**
 给label一部分字符串设置不同颜色
 
 @param allString 整体字符串内容
 @param colorStrArr  要改变颜色的字符串
 @param color     设置的颜色
 @param font      字号
 @return          获得可变字符串
 */
+ (NSMutableAttributedString *)attrStrFrom:(NSString *)allString colorStr:(NSArray *)colorStrArr color:(UIColor *)color font:(UIFont *)font;

+ (NSArray*)getURLFromStr:(NSString *)string;

+ (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string;
@end

NS_ASSUME_NONNULL_END

/*
 *  @header LEEThemeHelper.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2019年 lee. All rights reserved.
 *  @version    V1.1.10
 */

FOUNDATION_EXPORT double TMLEEThemeVersionNumber;
FOUNDATION_EXPORT const unsigned char TMLEEThemeVersionString[];

#ifndef LEEThemeHelper_h
#define LEEThemeHelper_h

@class TMLEEThemeConfigModel;

#pragma mark - 宏

#define LEEColorRGBA(R , G , B , A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define LEEColorRGB(R , G , B) LEEColorRGBA(R , G , B , 1.0f)

#define LEEColorHex(hex) [UIColor leeTheme_ColorWithHexString:hex]

#define LEEColorFromIdentifier(tag, identifier) ({((UIColor *)([IMLEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEImageFromIdentifier(tag, identifier) ({((UIImage *)([IMLEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEValueFromIdentifier(tag, identifier) ({([IMLEETheme getValueWithTag:tag Identifier:identifier]);})

#pragma mark - typedef

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMLEEThemeConfigBlock)(id item);
typedef void(^TMLEEThemeConfigBlockToValue)(id item , id value);
typedef void(^TMLEEThemeChangingBlock)(NSString *tag , id item);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigTheme)(void);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToFloat)(CGFloat number);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToTag)(NSString *tag);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToKeyPath)(NSString *keyPath);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelector)(SEL selector);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifier)(NSString *identifier);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToChangingBlock)(TMLEEThemeChangingBlock);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_KeyPath)(NSString *tag , NSString *keyPath);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Selector)(NSString *tag , SEL selector);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Color)(NSString *tag , id color);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Image)(NSString *tag , id image);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Block)(NSString *tag , TMLEEThemeConfigBlock);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToTs_Block)(NSArray *tags , TMLEEThemeConfigBlock);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToKeyPathAndIdentifier)(NSString *keyPath , NSString *identifier);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndIdentifier)(SEL sel , NSString *identifier);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndIdentifierAndValueIndexAndValueArray)(SEL sel , NSString *identifier , NSInteger valueIndex , NSArray *otherValues);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndValues)(SEL sel , NSArray *values);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifierAndState)(NSString *identifier , UIControlState state);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_ColorAndState)(NSString *tag , UIColor *color , UIControlState state);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_ImageAndState)(NSString *tag , UIImage *image , UIControlState state);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_KeyPathAndValue)(NSString *tag , NSString *keyPath , id value);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndColor)(NSString *tag , SEL sel , id color);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndImage)(NSString *tag , SEL sel , id image);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndValues)(NSString *tag , SEL sel , ...);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndValueArray)(NSString *tag , SEL sel , NSArray *values);
typedef TMLEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifierAndBlock)(NSString *identifier , TMLEEThemeConfigBlockToValue);

NS_ASSUME_NONNULL_END

#endif /* LEEThemeHelper_h */

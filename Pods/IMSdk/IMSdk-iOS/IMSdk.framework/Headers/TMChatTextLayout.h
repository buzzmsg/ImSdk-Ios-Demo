//
//  TMChatTextLayout.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMText.h"


NS_ASSUME_NONNULL_BEGIN

@interface TMChatTextLayout : NSObject


@property (nonatomic, assign) CGFloat textHeight; // Text height (including blank space below)
@property (nonatomic, assign) CGFloat textWidth;  // Wide text   (including blank space below)

@property (nonatomic,assign) CGSize chatBaseRightSize;
@property (nonatomic,assign) CGSize chatBaseLeftSize;

@property (nonatomic, strong) TMTextLayout *textLayout; // text

- (void)layoutWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor matchTextColor:(UIColor *)matchTextColor matchTextHighlightBGColor:(UIColor *)matchTextHighlightBGColor MaxWidth:(CGFloat)maxWidth;

- (void)layoutWithTip:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor matchTextColor:(UIColor *)matchTextColor matchTextHighlightBGColor:(UIColor *)matchTextHighlightBGColor;

// Red envelope Tip
- (void)layoutWithKeseTip:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor matchTextColor:(UIColor *)matchTextColor matchTextHighlightBGColor:(UIColor *)matchTextHighlightBGColor;

- (void)layoutWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor matchTextColor:(UIColor *)matchTextColor matchTextHighlightBGColor:(UIColor *)matchTextHighlightBGColor withCallType:(int)CallType withisVideo:(BOOL) isVideo isIncome:(BOOL)isIncome;


- (void)layoutWithText:(NSString *)text timeText:(NSString *)timeText fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor matchTextColor:(UIColor *)matchTextColor matchTextHighlightBGColor:(UIColor *)matchTextHighlightBGColor MaxWidth:(CGFloat)maxWidth;

- (BOOL)didTextMoveToNewline:(NSString *)text previousHeight:(CGFloat)previousHeight appendText:(NSString *)appendText MaxWidth:(CGFloat)maxWidth;


- (void)getLayoutWithText:(NSString *)text fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor MaxWidth:(CGFloat)maxWidth;

- (void)getLayoutWithMomentText:(NSMutableAttributedString *)text fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor;

- (void)layoutWithCommon:(NSString *)text fontSize:(CGFloat)fontSize maxLenth:(int)maxLenth maxWidth:(int)maxWidth;

- (void)layoutWithText:(NSString *)content timeStr:(NSString *)timeStr contentFontSize:(NSInteger)contentFontSize timeFontSize:(CGFloat)timeFontSize MaxWidth:(CGFloat)maxWidth;
- (void)layoutWithQuotoText:(NSMutableAttributedString *)content contentFontSize:(NSInteger)contentFontSize width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode truncationType:(TMTextTruncationType)truncationType;


@end

NS_ASSUME_NONNULL_END

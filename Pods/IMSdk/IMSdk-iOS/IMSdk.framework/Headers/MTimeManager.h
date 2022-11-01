//
//  MTimeManager.h
//  TMM
//
//   on 2021/8/16.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTimeManager : NSObject
+ (NSMutableArray *)getChatGroupWithTime:(NSArray *)arr;
+ (NSArray *)assemblyChatGroupData:(NSArray *)arr;
+ (NSString *)getTimeFromTimestamp:(NSInteger)time;
+ (NSArray *)getNewArr:(NSArray *)arr;
+ (NSArray *)swiftGetNewArr:(NSArray *)arr;
+ (CGFloat)getStringWidth:(NSString *)text fontSize:(CGFloat)fontSize;
+ (CGFloat)getStringheight:(NSString*)text fontSize:(CGFloat)fontSize;
+ (UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;
+ (NSString *)checkTheDate:(NSString *)string;
//
+ (NSArray *)swiftDeleteWithMids:(NSArray *)dataArray Mids:(NSArray *)mids;
+ (NSArray *)swiftDataWithAssemblyOrAdd:(NSArray *)dataArray MsgList:(NSArray*)msgList;
@end

NS_ASSUME_NONNULL_END

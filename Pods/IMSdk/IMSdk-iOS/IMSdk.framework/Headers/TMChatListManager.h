//
//  TMChatListManager.h
//  TMM
//
//  Created by oceanMAC on 2022/7/26.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TmConversationInfo;
@interface TMChatListManager : NSObject

+(TMChatListManager *)shared;

- (NSAttributedString *)updateDraftContent:(NSString *)content bodyLabel:(UITextView *)bodyLabel;

- (NSAttributedString *)updateContent:(NSString *)content tmInfo:(TmConversationInfo *)tmInfo bodyLabel:(UITextView *)bodyLabel;

- (void)enumerateObjects:(UIColor *)color bodyLabel:(UITextView *)bodyLabel;


-(void)setupNoticeContent:(NSArray<TmConversationInfo *> *)tmInfos;
-(void)setupGroupChatName:(NSArray<TmConversationInfo *> *)tmInfos;

@end

NS_ASSUME_NONNULL_END

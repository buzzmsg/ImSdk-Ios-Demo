//
//  IMChatListManager.h
//  TMM
//
//  Created by oceanMAC on 2022/7/26.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IMConversationInfo, IMContext;
@interface IMChatListManager : NSObject

@property (nonatomic, strong) IMContext *context;

+(IMChatListManager *)shared;

- (NSAttributedString *)updateDraftContent:(NSString *)content bodyLabel:(UITextView *)bodyLabel;

- (NSAttributedString *)updateContent:(NSString *)content tmInfo:(IMConversationInfo *)tmInfo bodyLabel:(UITextView *)bodyLabel;

- (void)enumerateObjects:(UIColor *)color bodyLabel:(UITextView *)bodyLabel;


-(void)setupNoticeContent:(NSArray<IMConversationInfo *> *)tmInfos;
-(void)setupGroupChatName:(NSArray<IMConversationInfo *> *)tmInfos;

@end

NS_ASSUME_NONNULL_END

//
//  TMChatTextCell.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import "ChatBaseCell.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^AudioBlock)(void);
typedef void(^VideoBlock)(void);
typedef void(^TMChatTextCellUrlBlock)(NSString *);

@class TMChatTextCell;
@protocol CellChatTextLeftDelegate <NSObject>

@optional

- (void)tapLeftAvatar;
- (void)translateMsg:(NSString *)msg inLeftCell:(TMChatTextCell *)leftCell;//Translate message
- (void)retweetMsg:(NSString *)msg inLeftCell:(TMChatTextCell *)leftCell;//Forward message
- (void)onLinkInChatTextLeftCell:(TMChatTextCell *)cell linkType:(int)linkType linkText:(NSString *)linkText;

- (void)clickQuotoMsg:(NSString *)msg inLeftCell:(TMChatTextCell *)leftCell;//clickQuoto message

@end

@interface TMChatTextCell : ChatBaseCell

@property (nonatomic,weak)id<CellChatTextLeftDelegate>delegate;
@property (nonatomic, copy) AudioBlock audioBlock;
@property (nonatomic, copy) VideoBlock videoBlock;
@property (nonatomic, copy) TMChatTextCellUrlBlock urlBlock;

- (void)layoutUI;

@end

NS_ASSUME_NONNULL_END

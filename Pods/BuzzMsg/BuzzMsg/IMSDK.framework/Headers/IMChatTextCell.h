//
//  IMChatTextCell.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import "IMChatBaseCell.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^AudioBlock)(void);
typedef void(^VideoBlock)(void);
typedef void(^TMChatTextCellUrlBlock)(NSString *);

@class IMChatTextCell;
@protocol CellChatTextLeftDelegate <NSObject>

@optional

- (void)tapLeftAvatar;
- (void)translateMsg:(NSString *)msg inLeftCell:(IMChatTextCell *)leftCell;//Translate message
- (void)retweetMsg:(NSString *)msg inLeftCell:(IMChatTextCell *)leftCell;//Forward message
- (void)onLinkInChatTextLeftCell:(IMChatTextCell *)cell linkType:(int)linkType linkText:(NSString *)linkText;

- (void)clickQuotoMsg:(NSString *)msg inLeftCell:(IMChatTextCell *)leftCell;//clickQuoto message

@end

@interface IMChatTextCell : IMChatBaseCell

@property (nonatomic,weak)id<CellChatTextLeftDelegate>delegate;
@property (nonatomic, copy) AudioBlock audioBlock;
@property (nonatomic, copy) VideoBlock videoBlock;
@property (nonatomic, copy) TMChatTextCellUrlBlock urlBlock;

- (void)layoutUI;

@end

NS_ASSUME_NONNULL_END

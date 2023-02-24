//
//  IMChatDetailViewController.h
//  TMM
//
//  Created by tmm on 2019/11/5.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSDKMessageAttachmentModel.h"

@class IMMessage, IMContext, IMOSS, IMMessageInfoModel, IMRedPackModel,IMLocationModel, IMChatDetailViewController, IMShowUserInfo;
@class IMLongPressPopView;
@class IMUISetting;
@class IMSdk;

@protocol TMMChatDetailCheckDelegate <NSObject>

- (void)tapfileAtIndexPath:(NSString *)mid;
- (void)tapImageAtIndexPath:(NSString *)chatId messageId:(NSInteger)messageId;
- (void)tapCardButonIndexPath:(NSString *)amid buttonId:(NSString *)buttonId;
- (void)clickTxtNoticeCardIndexPath:(NSString *)amid buttonId:(NSString *)buttonId;
- (void)tapMessageText:(NSString *)amid tempId:(NSString *)tempId textId:(NSString *)textId;
- (void)getMessageUnReadCount:(NSInteger)count;
- (void)selectMessageAct;
- (void)tapMessageReportText:(NSString *)amid;
- (void)quoteMessage:(NSString *)amid sender:(NSString *)sender attr:(NSAttributedString *)attr;
- (void)forwardMessage:(NSString *)amid;
- (void)tapTransferMessage:(NSString *)amid orderId:(NSString *)orderId;
- (void)tapPayNoticeMessage:(NSString *)amid outTradeNo:(NSString *)outTradeNo orderId:(NSString *)orderId act:(NSInteger)act;

- (void)tapReferenceMessageIsDeleted:(NSString *)amid;
- (void)tapReferenceMessage:(NSString *)amid content:(NSString *)content;

- (void)refreshRedEnvelopeStatusChange:(NSString *)amid outTradeNo:(NSString *)outTradeNo;

- (void)momentAtFeed:(NSString *)feedId;//
- (void)tapLocationAtIndexPath:(NSString *)mid location: (IMLocationModel *)location;

- (void)GetRedPacket:(IMRedPackModel *)redPackModel;//

- (void)longPressUserAvatar:(NSString *)aUid;
- (void)tapUserAvatar:(NSString *)aUid;

- (void)tapMeetingCallRecord:(NSString *)aChatId uid: (NSString *)aUid isVideo: (BOOL)isVideo;

- (void)setGroupMemberInfoWithController:(IMChatDetailViewController *)controller datas:(NSArray<IMShowUserInfo *> *)datas;

- (void)tapRedPacketNotice:(NSString *)amid outTradeNo:(NSString *)outTradeNo;


- (void)deleteMessageForMe:(NSString *)amid senderAUid:(NSString *)aUid;
- (void)deleteMessageForEveryOne:(NSString *)amid senderAUid:(NSString *)aUid;

- (void)detailDidSelectRow;
- (IMSdk *)getIMSdkInstance;

@end

NS_ASSUME_NONNULL_BEGIN

//@class TMSearchChatMsgResultModel;
@interface IMChatDetailViewController : UIViewController

//ocean new
@property (nonatomic, strong) NSString *chatId;
//@property (nonatomic, strong) IMMessage *draftTmMessage;
@property (nonatomic, assign) BOOL isSearch;
//@property (nonatomic, strong) TMSearchChatMsgResultModel *searchModel;
@property (nonatomic, strong) IMMessage *searchModel;

@property (nonatomic,weak) id<TMMChatDetailCheckDelegate> checkDelegate;
@property (nonatomic, strong) IMContext *context;
@property (nonatomic, strong) IMOSS *oss;
@property (nonatomic, strong) IMUISetting *uiSetting;
@property (nonatomic, strong) NSMutableArray *selectMessagesArr;

- (void)getChatId:(NSString *)chatId aChatId:(NSString *)aChatId;

- (NSArray <NSString *>*)getForwardSelectMids;

@property (nonatomic, strong, nullable) IMLongPressPopView * longView;

- (void)onCancleMessageMultipleChoose;

+ (NSAttributedString *)getQuoteAttr:(IMMessageInfoModel *)model;

- (UIImageView *)getClickImageView:(NSInteger)mid;
- (void)setTableViewContentInset:(UIEdgeInsets)inset;
- (void)setTableViewScrollIndicatorInsets:(UIEdgeInsets)inset;
- (void)setTableViewContentOffset:(CGPoint)offset animated:(BOOL)animated;
- (UIEdgeInsets)getTableViewContentInset;
- (UIEdgeInsets)getTableViewScrollIndicatorInsets;
- (CGPoint)getTableViewContentOffset;
- (CGSize)getTableViewContentSize;

-(BOOL)reloadRowIfDataModelIsShow: (NSString *)mid;
-(BOOL)dataModelIsShow: (NSString *)mid;

@end

NS_ASSUME_NONNULL_END

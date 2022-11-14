//
//  TMMessageModel.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMText.h"
#import "TMChatTextLayout.h"
#import "TMMessageAttachmentModel.h"
#import "TMMessageQuotoModel.h"

#define TMAvatarTopToContentTop 8.0
#define TMNickNameHeight 14.0
#define TMBodyTopToNickName 5.0
#define TMTimeLabelTopToBodyBottom 7.0
#define TMStatuImgHeight 15.0
#define TMStatuImgBottomToContentBottom 8.0

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHMessageDeliveryState) {
    
    Download_Success = 1,
    Download_Failed,
    Download_Illegal,
    Not_Require,
    Downloading,
    Uploading,
    Uploading_Success,
    Uploading_Failed
    
//    YHMessageDeliveryState_UNREAD = 0,   //
//    YHMessageDeliveryState_READ,   //
//    YHMessageDeliveryState_PENDING,   //
//    YHMessageDeliveryState_SENT,    //
//    YHMessageDeliveryState_DELIVERED,      //
//    YHMessageDeliveryState_DELIVERED_AND_READ   //
};
typedef NS_ENUM(NSUInteger, TMMessageContentType) {
    TMMessageContentType_UNKNOWN = 0,
    TMMessageContentType_DEFAULT = 1,   // Text message
    TMMessageContentType_IMAGE,   // image
    TMMessageContentType_AUDIO,  // recording
    TMMessageContentType_VIDEO,   // video
    TMMessageContentType_FILE,   // file
    TMMessageContentType_SendRedEnvelope = 6, // SendRedEnvelope
    TMMessageContentType_CoinTransfer = 7, // transfer
//    TMMessageContentType_Call = 8,  // Audio and video calls
    TMMessageContentType_MiniProgram = 9,  //
    TMMessageContentType_Moments = 10,  // moments
    TMMessageContentType_payNotice = 11, // pay notice
    TMMessageContentType_getRedEnvelope = 12,//get RedEnvelope
    TMMessageContentType_Location = 13,// user location
    TMMessageContentType_meeting = 14, // meeting
    TMMessageContentType_AT_Person = 15, // @xxxx  @all
    TMMessageContentType_HollowManStatus = 18, //HollowMan-msg
    TMMessageContentType_CardMessage = 19,
    TMMessageContentType_RevokeStatus = 81, //ContentType_Revoke-msg
    TMMessageContentType_UidTextA = 20,
    TMMessageContentType_TextSystemNotice = 21,
    
    
    // Only use to local for UI
    TMMessageContentType_HistoryPosiation,

    
//    TMMessageContentType_RedPacket,  // Red envelope 🧧
//    TMMessageContentType_LOCATION,  // Positioning
//    TMMessageContentType_NOTIFACATION,   // tip group prompt
//    TMMessageContentType_takePacket,  // Open the red envelope message 🧧
//    TMMessageContentType_Transfer,  // Transfer
//    TMMessageContentType_SplitBill,  // Group collection
//    TMMessageContentType_SplitBillTip,  // Group collection reminder message
//    TMMessageContentType_VCard,  // business card
//    TMMessageContentType_OfficialAccountCard,  // business card
//    TMMessageContentType_ImageLink,  //
//    TMMessageContentType_ForwardImageLink,  //
//    TMMessageContentType_Moment,  //
//    TMMessageContentType_Nearby,  //
//    TMMessageContentType_CoinTransaction,  //Coin Transaction
//    TMMessageContentType_VoiceCallStatus, //Voice call status ： start or end
};

/**
 会话类型

 - Single_Type: 单聊
 - Group_Type: 群组
 - Chatroom_Type: 聊天室
 - Channel_Type: 频道
 - Things_Type: 物联网
 */
typedef NS_ENUM(NSInteger, TMConversationType) {
    Single_Type,
    Group_Type,
    Chatroom_Type,
    Channel_Type,
    Things_Type,
};


/**
 消息状态

 - Message_Status_Sending: 发送中
 - Message_Status_Sent: 发送成功
 - Message_Status_Send_Failure: 发送失败
 - Message_Status_Unread: 未读
 - Message_Status_Readed: 已读
 - Message_Status_Played: 已播放(媒体消息)
 */
typedef NS_ENUM(NSInteger, TMMessageStatus) {
    Message_Status_Sending,
    Message_Status_Sent,
    Message_Status_Send_Failure,
    Message_Status_Readed,
    Message_Status_Mentioned,
    Message_Status_AllMentioned,
    Message_Status_Unread,
    Message_Status_Played
};

@class TmMessageContent;
@class TmMessage;
@class TMChatMeetingModel;
@interface TMMessageModel : NSObject

@property (nonatomic, assign)BOOL isCountSingle;

@property (nonatomic, assign)BOOL isRecord;
@property (nonatomic, assign)BOOL isSearchAnimation;
@property (nonatomic, copy)NSString *searchMessageId;

@property (nonatomic, copy) NSString *fromUser;
@property (nonatomic, copy) NSString *seed;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) long long serverTime;
@property (nonatomic, assign) long long displayTime;

@property (nonatomic, assign, readonly) long long serverSecondsTime;
@property (nonatomic, assign)TMMessageStatus status;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *vCode; //version Code
@property (nonatomic, copy) NSString *aMid;

@property (nonatomic, assign) BOOL isTranslate; //Whether to translate
@property (nonatomic, assign) BOOL isTranslating; //Are you translating
@property (nonatomic, assign)NSInteger translateIosStatus; //0:no 1:statrt 2:sucess 3:fail
@property (nonatomic, assign) BOOL isSame; //
@property (nonatomic, assign) BOOL isChangeHistoryTop; //yes:20 no:12

@property (nonatomic, assign) BOOL isLocal; //

@property (nonatomic, assign) BOOL isQuoto; //
@property (nonatomic, strong) NSString *quotoStr; //
@property (nonatomic, strong) TMMessageQuotoModel *quotoModel; //
@property (nonatomic, copy) NSAttributedString * quotoAttString; //
@property (nonatomic, assign) CGSize quotoSize;  //
@property (nonatomic, strong) NSString *groupId; //
@property (nonatomic, copy) NSString *translateStr;
@property (nonatomic, strong) TMChatTextLayout * translatelayout;
@property (nonatomic, copy) NSString *MessageKey;   //
@property (nonatomic, copy) NSString *msgContent;   //

@property (nonatomic, assign) CGSize chatBaseLeftSize;   //
@property (nonatomic, assign) CGSize chatBaseRightSize;   //
@property (nonatomic, assign) CGSize msgSize;   //
@property (nonatomic, copy) NSString *nameAlias;   //
@property (nonatomic, copy) id moContentMediaModel;   //
@property (nonatomic, strong) TmMessageContent *msgContentModel;
@property (nonatomic, strong) TmMessage *originalMessage;
@property (nonatomic, strong) TMChatMeetingModel *meeting;


//@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *createTime;   //
//@property (nonatomic, copy) NSNumber *createdAtTime; //
@property (nonatomic, copy) NSString *sid;   //
@property (nonatomic, assign) BOOL isGroupMessage;  //
@property (nonatomic, copy) NSString *speakerName;  //
@property (nonatomic, copy) NSURL *speakerAvatar;   //
@property (nonatomic, assign) BOOL isInComingMessage;  //
@property (nonatomic,copy) NSString * nickName;       //
@property (nonatomic, assign) YHMessageDeliveryState deliveryState;//Message sending status
@property (nonatomic, assign) BOOL isSendToServer;
@property (nonatomic, assign) BOOL isPlayingAudio;      // Whether sound is playing
@property (nonatomic, assign) float playAudioProgross;  // Play sound progress
@property (nonatomic, assign) TMMessageContentType contentType;          //Message type
@property (nonatomic, strong) TMMessageAttachmentModel *attachment;   //attachment content
@property (nonatomic, strong) TMMessageLoactionModel *loactonModel;   //location content
@property (nonatomic, strong) TMMessageRedpacketModel *redpacketModel;   //Red envelope content
@property (nonatomic, strong) TMMessagetakePacketModel *takePacketModel;   //Open red envelope content
@property (nonatomic, strong) TMMessageTransferModel *transferModel;   //Transfer content
@property (nonatomic, strong) TMMessageSplitBillModel *splitBillModel;   //Group collection content
@property (nonatomic, strong) TMMessageSplitBillTipModel *splitBillTipModel;   //Group collection content Tip message
@property (nonatomic, strong) TMMessageVCardModel *vCardModel;   //Business card information
@property (nonatomic, strong) TMMessageOfficialAccountCardModel *officialAccountCardModel;   // Official Account card information
@property (nonatomic, strong) TMMessageMiniProgarmModel *miniprogramModel;   //miniprogram Model
@property (nonatomic, strong) TMMessageCoinTransactionModel *coinTransactionModel;   //
@property (nonatomic, strong) NSArray<TMMessageImageLinkModel *> *imageLinkModelArr;
@property (nonatomic, strong) TMMessageMomentModel *momentModel;   //
@property (nonatomic, strong) TMMessageNearbyModel *nearbyModel;   //
@property (nonatomic, strong) TMMessageVoiceCallStatusModel *callStatusModel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isSelected;    // chosen
@property (nonatomic, assign) BOOL showCheckBox;  // Show check box
@property (nonatomic, strong) TMChatTextLayout *layout;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, assign) int messageContentType;
@property (nonatomic, assign)long messageId;
@property (nonatomic, assign)long long messageUid;

@property (nonatomic, assign)CGFloat downProgress; //
@property (nonatomic, assign)NSInteger downStatus;
@property (nonatomic, assign) BOOL isThird;

// WCDB Property
@property (nonatomic, assign) long sequence;
@property (nonatomic, assign) long _id;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) long createTime;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) CGSize textSize;
//@property (nonatomic, strong) NSMutableAttributedString *attachTextStr;

@property (nonatomic, strong) NSAttributedString *attachTextStr;

@property (nonatomic, assign)TMConversationType chatType;
@property (nonatomic, assign) BOOL isSingle;



- (float)returnImageLinkHeight;
- (float)returnORIImageLinkHeight;
- (float)returnMiniProgramHeight;
- (float)returnNearByHeight;
- (float)returnMomentHeight;
- (CGSize)returnFileContentSize;

@end

NS_ASSUME_NONNULL_END

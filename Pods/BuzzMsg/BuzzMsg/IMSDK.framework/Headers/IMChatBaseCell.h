//
//  IMChatBaseCell.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageInfoModel.h"

#import <Masonry/Masonry.h>

#import "IMChatCellConst.h"

NS_ASSUME_NONNULL_BEGIN

@class IMChatBaseCell, SDAnimatedImageView,IMCallHeadImageView, IMOSS, IMShowUserInfo, IMUISetting;

@protocol TMMCellChatBaseDelegate <NSObject>

@optional

- (void)onCheckBoxAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model withSelect:(BOOL)isSelect;  //Selected

- (void)tapRedPacketAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model; //Click on the red envelope

- (void)tapTransferAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click Transfer

- (void)tapSplitBillAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to collect

- (void)tapAudioAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //voice

- (void)slideAudioBeginAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //voice

- (void)slideAudioEndAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model slideValue:(float)slideValue;  //voice

- (void)tapImageAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Picture Viewer

- (void)tapVideoAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Video player

- (void)tapfileAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click the file

- (void)tapVCardAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click on the business card

- (void)tapLocationAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to locate

- (void)recallAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to reCall

- (void)forwardAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to forward

- (void)selectAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to Select

- (void)quotoAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click to quoto

- (void)miniProgramAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click on the miniProgram

- (void)imageLinkAtIndexPath:(NSIndexPath *)indexPath model:(TMessageImageLinkModel *)model;  //Click on the miniProgram

- (void)nearbyAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click on the business card

- (void)momentAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  //Click on the business card

- (void)mentionedAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;  // mention

- (void)deleteMessageInCell:(UITableViewCell *)cell;  // delete

- (void)revokeAllMessageInCell:(UITableViewCell *)cell;  // delete

- (BOOL)groupIsDismissedInCell:(UITableViewCell * _Nullable)cell;

- (void)taptranslateAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;   // translate

- (void)taptranslateHideAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;   // translate

// Not In Use
- (NSArray<UIMenuItem *> *)longPressMenusItemsInCell:(IMChatBaseCell *)cell;

- (void)reportMessageAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;   // report

- (void)clickCardButton:(NSString *)amid buttonId:(NSString *)buttonId;
- (void)clickTextNoticeCard:(NSString *)amid buttonId:(NSString *)buttonId;

- (void)setGroupMemberInfoWithIndexPath:(NSIndexPath *)indexPath datas:(NSArray<IMShowUserInfo *> *)datas;
- (void)tapAvatarAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;

- (void)tapMeetingCallAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;

- (void)tapRedPacketNoticeMessageAtIndexPath:(NSIndexPath *)indexPath model:(IMMessageInfoModel *)model;   // report

@end

@interface IMChatBaseCell : UITableViewCell


#pragma mark - Public Data
@property (nonatomic,strong) IMMessageInfoModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<TMMCellChatBaseDelegate> baseDelegate;

@property (nonatomic,assign) BOOL showCheckBox;
@property (nonatomic, strong, readonly) UIButton *checkBoxFullCellButton;

@property (nonatomic, strong) IMOSS *oss;
@property (nonatomic, strong) IMUISetting *uiSetting;


#pragma mark - Public Controls
@property (nonatomic,strong) UILabel *lbTime;    //Speaking time
@property (nonatomic,strong) UILabel *lbName;    //Speaker's name
//@property (nonatomic,strong) SDAnimatedImageView *imgvAvatar;//Publisher avatar
@property (nonatomic,strong) IMCallHeadImageView *headImageView;//Publisher avatar

//@property (nonatomic,strong) TMChatHeadImageView *headImageView;//Publisher avatar


@property (nonatomic,strong) UIImageView *imgvSendMsgStatus;//Send status icon

@property (nonatomic, strong, readonly) UIView *containerView;



@property (nonatomic,strong) UIButton * btnCheckBox;//Selection box
@property (nonatomic,assign) BOOL  isInComingMessage;
#pragma mark - Public Gesture


//Click on user avatar
- (void)onAvatarGesture:(UIGestureRecognizer *)aRec;

//Click the send failed icon
- (void)onImgSendMsgFailGesture:(UIGestureRecognizer *)aRec;

#pragma mark - Public Method
//Set up the Model
//- (void)playSendSuccessSound:(IMMessageInfoModel *)model;
- (void)setupModel:(IMMessageInfoModel *)model;


//Click the check box
- (void)onBtnCheckBox:(UIButton *)sender;

- (void)longPress:(UILongPressGestureRecognizer *)gesture;

//Layout common UI
- (void)layoutCommonUI;

- (void)menuDelete:(UIMenuController *)menu;

- (void)isHiddenLoading;

- (void)forward:(UIMenuController *)menu;

- (void)moreSelect:(UIMenuController *)menu;

- (void)quoto:(UIMenuController *)menu;

- (void)subCellMakeBtnCheckBoxConstraints:(UIView *)centerView;


@end

NS_ASSUME_NONNULL_END

//
//  ChatBaseCell.h
//  TMM
//
//  Created by tmm on 2019/11/6.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMMessageModel.h"

#import <Masonry/Masonry.h>

#import "TMChatCellConst.h"

NS_ASSUME_NONNULL_BEGIN

@class ChatBaseCell, SDAnimatedImageView,TMCallHeadImageView;

@protocol CellChatBaseDelegate <NSObject>

@optional

- (void)onCheckBoxAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model withSelect:(BOOL)isSelect;  //Selected

- (void)tapRedPacketAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model; //Click on the red envelope

- (void)tapTransferAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click Transfer

- (void)tapSplitBillAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to collect

- (void)tapAudioAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //voice

- (void)slideAudioBeginAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //voice

- (void)slideAudioEndAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model slideValue:(float)slideValue;  //voice

- (void)tapImageAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Picture Viewer

- (void)tapVideoAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Video player

- (void)tapfileAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click the file

- (void)tapVCardAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click on the business card

- (void)tapLocationAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to locate

- (void)recallAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to reCall

- (void)forwardAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to forward

- (void)selectAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to Select

- (void)quotoAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click to quoto

- (void)miniProgramAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click on the miniProgram

- (void)imageLinkAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageImageLinkModel *)model;  //Click on the miniProgram

- (void)nearbyAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click on the business card

- (void)momentAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  //Click on the business card

- (void)mentionedAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;  // mention

- (void)deleteMessageInCell:(UITableViewCell *)cell;  // delete

- (BOOL)groupIsDismissedInCell:(UITableViewCell * _Nullable)cell;

- (void)taptranslateAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;   // translate

- (void)taptranslateHideAtIndexPath:(NSIndexPath *)indexPath model:(TMMessageModel *)model;   // translate

// Not In Use
- (NSArray<UIMenuItem *> *)longPressMenusItemsInCell:(ChatBaseCell *)cell;


- (void)clickCardButton:(NSString *)amid buttonId:(NSString *)buttonId;

@end

@interface ChatBaseCell : UITableViewCell


#pragma mark - Public Data
@property (nonatomic,strong) TMMessageModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<CellChatBaseDelegate> baseDelegate;

@property (nonatomic,assign) BOOL showCheckBox;
@property (nonatomic, strong, readonly) UIButton *checkBoxFullCellButton;


#pragma mark - Public Controls
@property (nonatomic,strong) UILabel *lbTime;    //Speaking time
//@property (nonatomic,strong) UILabel *lbName;    //Speaker's name
//@property (nonatomic,strong) SDAnimatedImageView *imgvAvatar;//Publisher avatar
@property (nonatomic,strong) TMCallHeadImageView *headImageView;//Publisher avatar

//@property (nonatomic,strong) TMChatHeadImageView *headImageView;//Publisher avatar


@property (nonatomic,strong) UIImageView *imgvSendMsgStatus;//Send status icon

//@property (nonatomic,strong) UIView *indicatorView;//Send status icon



@property (nonatomic,strong) UIButton * btnCheckBox;//Selection box
@property (nonatomic,assign) BOOL  isInComingMessage;
#pragma mark - Public Gesture


//Click on user avatar
- (void)onAvatarGesture:(UIGestureRecognizer *)aRec;

//Click the send failed icon
- (void)onImgSendMsgFailGesture:(UIGestureRecognizer *)aRec;

#pragma mark - Public Method
//Set up the Model
- (void)setupModel:(TMMessageModel *)model;


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

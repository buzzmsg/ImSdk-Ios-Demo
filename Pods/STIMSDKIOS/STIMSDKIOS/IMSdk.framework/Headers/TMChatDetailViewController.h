//
//  TMChatDetailViewController.h
//  TMM
//
//  Created by tmm on 2019/11/5.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMMessageAttachmentModel.h"

@class TmMessage;

@protocol ChatDetailCheckDelegate <NSObject>

- (void)tapfileAtIndexPath:(NSString *)mid;
- (void)tapImageAtIndexPath:(NSString *)chatId messageId:(NSInteger)messageId;
- (void)tapCardButonIndexPath:(NSString *)amid buttonId:(NSString *)buttonId;
- (void)clickTxtNoticeCardIndexPath:(NSString *)amid buttonId:(NSString *)buttonId;
- (void)tapMessageText:(NSString *)amid tempId:(NSString *)tempId textId:(NSString *)textId;
- (void)getMessageUnReadCount:(NSInteger)count;

- (void)getCustomView:(NSString *)amid body:(NSString *)body handleCustomView:(void(^)(UIView *itemView))handle tapCustomView:(void(^)(UIView *itemView))tap;

@end

NS_ASSUME_NONNULL_BEGIN

//@class TMSearchChatMsgResultModel;
@interface TMChatDetailViewController : UIViewController

//ocean new
@property (nonatomic, strong) NSString *chatId;
//@property (nonatomic, strong) TmMessage *draftTmMessage;
@property (nonatomic, assign) BOOL isSearch;
//@property (nonatomic, strong) TMSearchChatMsgResultModel *searchModel;

@property (nonatomic,weak) id<ChatDetailCheckDelegate> checkDelegate;

- (void)getChatId:(NSString *)chatId;

- (void)setTableViewContentInset:(UIEdgeInsets)inset;
- (void)setTableViewScrollIndicatorInsets:(UIEdgeInsets)inset;
- (void)setTableViewContentOffset:(CGPoint)offset animated:(BOOL)animated;
- (UIEdgeInsets)getTableViewContentInset;
- (UIEdgeInsets)getTableViewScrollIndicatorInsets;
- (CGPoint)getTableViewContentOffset;
- (CGSize)getTableViewContentSize;


@end

NS_ASSUME_NONNULL_END

//
//  IMChannelListViewController.h
//  TMM
//
//  Created by tmm on 2019/11/4.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class IMChannelListViewController;
@class IMShowUserInfo;
@protocol TMMChannelListCheckDelegate <NSObject>

- (void)didSelectAchatId:(NSString *)aChatId;
- (void)setGroupMemberInfoWithController:(IMChannelListViewController *)controller datas:(NSArray<IMShowUserInfo *> *)datas;
- (void)tableViewDidScroll:(UIScrollView *)tableView;
- (void)tableViewDidEndDecelerating:(UIScrollView *)tableView;
- (void)tableViewDidEndDragging:(UIScrollView *)tableView willDecelerate:(BOOL)decelerate;

@end

@class IMConversationInfo,IMConversionViewModel;

@interface IMChannelListViewController : UIViewController

//@property (nonatomic, strong) NSArray *aChatId;

//@property (nonatomic, strong) NSArray *conversationInfos;

- (void)refreshListWhenReseletTabBar;
@property (nonatomic,weak) id<TMMChannelListCheckDelegate> delegate;

//- (void)getConversions:(NSArray *)chatIds isAll:(BOOL)isAll folderInfo:(IMConversationInfo *)folderInfo;

- (void)getViewModel:(IMConversionViewModel *)conversionViewModel;
- (void)setTableHeaderView:(UIView *)headerView;
- (void)setTableViewContentInset:(UIEdgeInsets)inset;
- (void)setTableViewScrollIndicatorInsets:(UIEdgeInsets)inset;
- (void)setTableViewContentOffset:(CGPoint)offset animated:(BOOL)animated;

- (void)setTableEmpytView:(UIView * _Nullable)empty;

@end



NS_ASSUME_NONNULL_END

//
//  TMChannelListViewController.h
//  TMM
//
//  Created by tmm on 2019/11/4.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol ChannelListCheckDelegate <NSObject>

- (void)didSelectAchatId:(NSString *)aChatId;

@end

@class TmConversationInfo,TMConversionViewModel;

@interface TMChannelListViewController : UIViewController

//@property (nonatomic, strong) NSArray *aChatId;

//@property (nonatomic, strong) NSArray *conversationInfos;

- (void)refreshListWhenReseletTabBar;
@property (nonatomic,weak) id<ChannelListCheckDelegate> delegate;

- (void)getConversions:(NSArray *)chatIds isAll:(BOOL)isAll folderInfo:(TmConversationInfo *)folderInfo;

- (void)getViewModel:(TMConversionViewModel *)conversionViewModel;

@end



NS_ASSUME_NONNULL_END

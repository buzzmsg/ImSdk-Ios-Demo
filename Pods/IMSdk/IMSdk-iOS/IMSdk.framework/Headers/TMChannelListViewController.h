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

@interface TMChannelListViewController : UIViewController


- (void)refreshListWhenReseletTabBar;
@property (nonatomic,weak) id<ChannelListCheckDelegate> delegate;

@end



NS_ASSUME_NONNULL_END

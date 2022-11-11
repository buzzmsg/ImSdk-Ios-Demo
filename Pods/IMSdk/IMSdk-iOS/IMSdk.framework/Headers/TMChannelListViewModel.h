//
//  TMChannelListViewModel.h
//  IMSdk
//
//  Created by oceanMAC on 2022/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMChatListDataEventBlock)(void);

@class TMConversionViewModel;
@interface TMChannelListViewModel : NSObject

+ (NSArray *)dataWithChangeLocation:(NSArray *)dataArray RefreshArr:(NSArray*)refreshArr conversionViewModel:(TMConversionViewModel *)conversionViewModel;


//remove chatId
+ (NSArray *)dataWithRemoveChatId:(NSArray *)dataArray ChatIdArr:(NSArray*)chatIdArr;


+ (void)handleConversationMessage:(NSArray *)dataArray;

+ (void)handleConversationMessage:(NSArray *)dataArray oldData: (NSMutableDictionary *)oldDataArray;

@end

NS_ASSUME_NONNULL_END

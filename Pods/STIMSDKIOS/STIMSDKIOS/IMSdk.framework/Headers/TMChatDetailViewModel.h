//
//  TMChatDetailViewModel.h
//  TMM
//
//  Created by  on 2021/8/9.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMMessageModel.h"
#import "TMChangeMasageModel.h"
@class TMMessageModel;
@class TMChangeMasageModel;
NS_ASSUME_NONNULL_BEGIN

@interface TMChatDetailViewModel : NSObject

//Data assembly
+ (NSArray *)dataWithAssemblyOrAdd:(NSArray *)dataArray MsgList:(NSArray*)msgList;
+ (NSArray *)dataWithAssemblyOrAdd:(NSArray *)dataArray MsgList:(NSArray*)msgList needAdd:(BOOL)needAdd;



+ (void)changeTmmassage:(NSArray *)dataArray queryMassage:(NSDictionary*)queryMassage uploadProgress:(double)uploadProgress completionHandle:(void(^)(NSArray * lastArray, NSInteger index))completed;


+ (NSArray *)dataWithReplace:(NSArray *)dataArray pageArr:(NSArray*)pageArr;

+ (void)FindTmmassage:(NSArray *)dataArray queryMassage:(id)fileEvent IsUpload:(BOOL)isUpload completionHandle:(void(^)(NSArray * lastArray, NSInteger index))completed;

//delete mid
+ (NSArray *)deleteWithMids:(NSArray *)dataArray Mids:(NSArray *)mids;

+ (void)clickFileWithStaus:(NSString *)fileId completionHandle:(void(^)(YHMessageDeliveryState fileStatus,NSInteger progress))completed;

+ (void)clickFileWithObjectId:(NSString *)objectId completionHandle:(void(^)(NSInteger progress))completed;

@end

NS_ASSUME_NONNULL_END

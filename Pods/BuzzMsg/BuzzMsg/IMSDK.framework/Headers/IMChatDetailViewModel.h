//
//  IMChatDetailViewModel.h
//  TMM
//
//  Created by  on 2021/8/9.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMMessageInfoModel.h"
#import "IMChangeMasageModel.h"
@class IMMessageInfoModel;
@class IMChangeMasageModel, IMContext;
@protocol IMGroupMemberDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface IMChatDetailViewModel : NSObject

//Data assembly
+ (NSArray *)dataWithAssemblyOrAdd:(NSArray *)dataArray MsgList:(NSArray*)msgList context:(IMContext *)context memberDelegate:(nullable id<IMGroupMemberDelegate>)memberDelegate;
+ (NSArray *)dataWithAssemblyOrAdd:(NSArray *)dataArray MsgList:(NSArray*)msgList needAdd:(BOOL)needAdd context:(IMContext *)context memberDelegate:(nullable id<IMGroupMemberDelegate>)memberDelegate;



+ (void)changeTmmassage:(NSArray *)dataArray queryMassage:(NSDictionary*)queryMassage uploadProgress:(double)uploadProgress context:(IMContext *)context memberDelegate:(nullable id<IMGroupMemberDelegate>)memberDelegate completionHandle:(void(^)(NSArray * lastArray, NSInteger index))completed;


+ (NSArray *)dataWithReplace:(NSArray *)dataArray pageArr:(NSArray*)pageArr;

+ (void)FindTmmassage:(NSArray *)dataArray queryMassage:(id)fileEvent IsUpload:(BOOL)isUpload completionHandle:(void(^)(NSArray * lastArray, NSInteger index))completed;

//delete mid
+ (NSArray *)deleteWithMids:(NSArray *)dataArray Mids:(NSArray *)mids;

+ (void)clickFileWithStaus:(NSString *)fileId completionHandle:(void(^)(YHMessageDeliveryState fileStatus,NSInteger progress))completed;

+ (void)clickFileWithObjectId:(NSString *)objectId completionHandle:(void(^)(NSInteger progress))completed;

@end

NS_ASSUME_NONNULL_END

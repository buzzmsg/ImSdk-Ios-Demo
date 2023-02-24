//
//  IMChangeMasageModel.h
//  TMM
//
//  Created by  on 2021/8/7.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class IMMessage,IMContext;
@protocol IMGroupMemberDelegate;
@interface IMChangeMasageModel : NSObject

+ (IMMessageInfoModel *)changgeModel:(IMMessage *)model context:(IMContext *)context memberDelegate:(nullable id<IMGroupMemberDelegate>)memberDelegate;

+ (NSString *)getTimeString:(IMMessageInfoModel *)model;

@end

NS_ASSUME_NONNULL_END

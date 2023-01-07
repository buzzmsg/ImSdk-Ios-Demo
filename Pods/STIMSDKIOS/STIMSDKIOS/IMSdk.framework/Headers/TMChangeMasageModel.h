//
//  TMChangeMasageModel.h
//  TMM
//
//  Created by  on 2021/8/7.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMMCompressPicManager.h"
#import "TMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TmMessage;
@interface TMChangeMasageModel : NSObject

+ (TMMessageModel *)changgeModel:(TmMessage *)model;

+ (NSString *)getTimeString:(TMMessageModel *)model;

@end

NS_ASSUME_NONNULL_END

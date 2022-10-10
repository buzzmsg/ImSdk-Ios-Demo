//
//  TMMD5.h
//  TMM
//
//  Created by apple on 2019/11/15.
//  Copyright © 2019 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMMD5 : NSObject

+ (NSString *)MD5:(NSString *)string;

+ (NSString *)HashNumber:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

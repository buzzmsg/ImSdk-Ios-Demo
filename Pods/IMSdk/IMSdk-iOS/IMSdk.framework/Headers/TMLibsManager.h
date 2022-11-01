//
//  TMLibsManager.h
//  IMSdk
//
//  Created by oceanMAC on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMLibsManager : NSObject

+ (instancetype)sharedInstance;
- (void)setupLog;

@end

NS_ASSUME_NONNULL_END

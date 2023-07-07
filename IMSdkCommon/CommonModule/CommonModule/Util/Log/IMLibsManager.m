//
//  TMMLibsManager.m
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/21.
//

#import "IMLibsManager.h"

@interface IMLibsManager()

@property (nonatomic, strong) DDFileLogger *loger;

@end

@implementation IMLibsManager

+ (instancetype)sharedInstance{
    static IMLibsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)setupLog{
    if (self.loger != nil) {
        return;
    }
    
#ifdef DEBUG
    if (@available(iOS 10.0, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    } else {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
#endif
    
//    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    directory = [directory stringByAppendingPathComponent: @"SDKLogs"];
    
    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES).lastObject;
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:directory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
   
    fileLogger.maximumFileSize = 1024*1024*5;
    fileLogger.logFileManager.logFilesDiskQuota = 1014*1024*40;
    
    [DDLog addLogger:fileLogger];
    
    self.loger = fileLogger;
}

- (DDFileLogger *)getFileLoger {
    return self.loger;
}

@end

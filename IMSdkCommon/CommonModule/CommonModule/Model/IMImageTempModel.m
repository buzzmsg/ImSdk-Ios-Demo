//
//  IMImageTempModel.m
//  TMM
//
//  Created by    on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import "IMImageTempModel.h"
#import "CommonModule/CommonModule-Swift.h"

@implementation IMImageTempModel

- (NSString *)filePath {
    return [[[IMPathManager shared] getOssDir] stringByAppendingString:self.objectId];
}

- (NSString *)primaryId {
    return [NSString stringWithFormat:@"%@%@",self.businessId, self.objectId];
}

@end
